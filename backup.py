#!/bin/env python
# -*- coding: utf-8 -*-
# PYTHON_ARGCOMPLETE_OK
"""
Azure blob storage writer

A command-line client for writing files to azure blob storage.
"""

import logging
import os
import sys
import time
from argparse import ArgumentParser, Namespace
from datetime import datetime
from typing import List

from azure.storage.blob import BlobServiceClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def is_affirmative(word: str) -> bool:
    return word.lower() in ["1", "true", "yes"]


def is_no_auth_provided(
    auth_vars: List[str] = ["AZURE_STORAGE_ACCESS_SECRET", "AZURE_SAS_URL"]
) -> bool:
    return all([os.getenv(x) is None for x in auth_vars])


def fetch_args() -> Namespace:
    parser = ArgumentParser(description=__doc__)
    parser.add_argument(
        "-a",
        "--account-name",
        default=os.getenv("AZURE_STORAGE_ACCOUNT", "foundationbackups"),
        required=os.getenv("AZURE_STORAGE_ACCOUNT") is None,
        help="Name of the azure storage account",
        type=str,
    )
    parser.add_argument(
        "-b",
        "--blob-name",
        default=datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ") + "-python",
        help="Name of the azure blob to be created",
        type=str,
    )
    parser.add_argument(
        "-c",
        "--container-name",
        default=os.getenv("AZURE_STORAGE_CONTAINER", "mender-backups"),
        required=os.getenv("AZURE_STORAGE_CONTAINER") is None,
        help="Name of the azure storage container",
        type=str,
    )
    parser.add_argument(
        "filenames",
        nargs="+",
        help="File(s) to be uploaded to blob storage.",
        type=str,
    )
    parser.add_argument(
        "-k",
        "--account-key",
        default=os.getenv("AZURE_STORAGE_ACCESS_SECRET"),
        required=is_no_auth_provided(),
        help="Azure storage account access secret key",
        type=str,
    )
    parser.add_argument(
        "-p",
        "--preserve-directory-structure",
        help="Preserve the directory structure of the file(s) being uploaded.",
        action="store_true",
        default=False,
    )
    parser.add_argument(
        "-s",
        "--sas-url",
        default=os.getenv("AZURE_SAS_URL"),
        required=is_no_auth_provided(),
        help="Azure SAS URL",
        type=str,
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        help="Provide more verbose output.",
    )

    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(0)
    return parser.parse_args()


def main() -> None:
    args = fetch_args()

    if args.account_key is not None:
        account_url = f"https://{args.account_name}.blob.core.windows.net/"
        service_client = BlobServiceClient(account_url, credential=args.account_key)
    else:
        service_client = BlobServiceClient(args.sas_url)

    blob_client = service_client.get_blob_client(args.container_name, args.blob_name)

    # try:
    #     if not block_blob_service.exists(container_name):
    #         block_blob_service.create_container(container_name)
    # except AzureHttpError:
    #     pass

    for filename in args.filenames:
        with open(filename, "rb") as data:
            blob_client.upload_blob(data)


if __name__ == "__main__":
    main()
