"""IAM policy and role Handler.

Checks if the Terraform provided IAM object contains either a custom policy or
override.

"""
from __future__ import print_function

import argparse
import base64
import collections
import copy
import io
import json
import logging
import os
import sys

DEFAULT_LOG_LEVEL = logging.DEBUG
LOG_LEVELS = collections.defaultdict(
    lambda: DEFAULT_LOG_LEVEL,
    {
        'critical': logging.CRITICAL,
        'error': logging.ERROR,
        'warning': logging.WARNING,
        'info': logging.INFO,
        'debug': logging.DEBUG
    }
)

# Lambda initializes a root logger that needs to be removed in order to set a
# different logging config
root = logging.getLogger()
if root.handlers:
    for handler in root.handlers:
        root.removeHandler(handler)

logging.basicConfig(
    filename='iam_handler.log',
    format='%(asctime)s.%(msecs)03dZ [%(name)s][%(levelname)-5s]: %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S',
    level=LOG_LEVELS[os.environ.get('LOG_LEVEL', '').lower()])
log = logging.getLogger(__name__)


def _join_paths(*paths):
    return "/".join(*paths).replace("//", "/")


def _read(path, encoding='utf8', **kwargs):
    """Read a file."""
    with io.open(path, encoding=encoding, **kwargs) as fh_:
        return fh_.read()


def _merge_iam_policy_doc(doc1, doc2):
    # adopt doc2's Id
    if doc2.get('Id'):
        doc1['Id'] = doc2['Id']

    # let doc2 upgrade our Version
    if doc2.get('Version', '') > doc1.get('Version', ''):
        doc1['Version'] = doc2['Version']

    # merge in doc2's statements, overwriting any existing Sids
    for doc2_statement in doc2['Statement']:
        if not doc2_statement.get('Sid'):
            doc1['Statement'].append(doc2_statement)
            continue

        seen = False
        for index, doc1_statement in enumerate(doc1['Statement']):
            if doc1_statement.get('Sid') == doc2_statement.get('Sid'):
                doc1['Statement'][index] = doc2_statement
                seen = True
                break

        if not seen:
            doc1['Statement'].append(doc2_statement)

    return doc1


def main(name, policy, template_paths, trust="", inline_policy="", **kwargs):
    """Merge policies and trusts for all template paths."""
    iam_policy_doc = {
        'Statement': []
    }

    iam_inline_policy_doc = {
        'Statement': []
    }

    ret = {}
    base = {
        'name': name,
        'policy': copy.deepcopy(iam_policy_doc),
        'inline_policy' : copy.deepcopy(iam_inline_policy_doc),
        'trust': copy.deepcopy(iam_policy_doc)
    }

    ret.update(base)
    ret.update(**kwargs)

    log.info('=' * 40)
    log.info('name = %s', name)
    log.info('policy = %s', policy)
    log.info('trust = %s', trust)
    log.info('template_paths = %s', template_paths)

    for path in template_paths.split(","):
        policy_path = _join_paths([path, policy])
        inline_policy_path = _join_paths([path, inline_policy])
        trust_path = _join_paths([path, trust])

        if os.path.isfile(policy_path):
            ret['policy'] = _merge_iam_policy_doc(
                ret['policy'],
                json.loads(_read(policy_path))
            )

        if os.path.isfile(inline_policy_path):
            ret['inline_policy'] = _merge_iam_policy_doc(
                ret['inline_policy'],
                json.loads(_read(inline_policy_path))
            )

        if os.path.isfile(trust_path):
            ret['trust'] = _merge_iam_policy_doc(
                ret['trust'],
                json.loads(_read(trust_path))
            )

    ret['policy'] = base64.b64encode(
        json.dumps(ret['policy']).encode('utf8')).decode('utf8')
    ret['inline_policy'] = (
        ret['policy'] if not ret['inline_policy']['Statement']
        else base64.b64encode(
            json.dumps(ret['inline_policy']).encode('utf8')).decode('utf8')
    )
    ret['trust'] = base64.b64encode(
        json.dumps(ret['trust']).encode('utf8')).decode('utf8')

    return ret


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "json", type=argparse.FileType("r"), default=sys.stdin,
        help="Parses input from a json file or stdin"
    )

    args = parser.parse_args()

    json_args = {}
    with args.json as fp_:
        json_args = json.load(fp_)
    sys.exit(print(json.dumps(main(**json_args))))
