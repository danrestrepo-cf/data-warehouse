"""Load all relevant tables with production-volume data to test loan_lender_user_access ETL performance.

2/8/2022 - CEdwards- Script created - https://app.asana.com/0/0/1201486823872698
"""
import sys
import os
import random
import datetime
import math
import concurrent.futures
from typing import Iterator, Optional, List
import io

# this line allows the script to import directly from python-utilities/lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory


def main():
    print(f'{datetime.datetime.now()} Starting')

    data_loader = MultithreadedDataLoader(
        loan_count=100000,
        user_count=12345,
        avg_users_per_loan=162,
        thread_count=10,
        table_schema='star_loan',
        table_name='loan_lender_user_access',
        columns=[
            'data_source_dwid',
            'edw_created_datetime',
            'edw_modified_datetime',
            'etl_batch_id',
            'data_source_integration_columns',
            'data_source_integration_id',
            'data_source_modified_datetime',
            'octane_username',
            'loan_dwid',
            'account_pid'
        ]
    )

    data_loader.truncate_previous_test_data()
    print(f'{datetime.datetime.now()} Finished removing previous test data')
    data_loader.load_all_test_data()
    print(f'{datetime.datetime.now()} Finished loading new test data')


class MultithreadedDataLoader:

    def __init__(self, loan_count: int, user_count: int, avg_users_per_loan: int, thread_count: int, table_schema: str, table_name: str,
                 columns: List[str]):
        self.loan_count = loan_count
        self.user_count = user_count
        self.avg_users_per_loan = avg_users_per_loan
        self.thread_count = thread_count
        self.thread_loan_range = math.ceil(loan_count / thread_count)
        self.table_schema = table_schema
        self.table_name = table_name
        self.columns = columns

    def load_all_test_data(self):
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.thread_count) as executor:
            executor.map(self.load_data_with_thread, range(self.thread_count))

    def load_data_with_thread(self, thread_num: int):
        row_generator = make_row_generator(
            loan_dwid_start=self.thread_loan_range * thread_num + 1,
            loan_dwid_end=min(self.thread_loan_range * thread_num + self.thread_loan_range, self.loan_count),
            user_count=self.user_count,
            avg_users_per_loan=self.avg_users_per_loan
        )
        with DBConnectionFactory().get_connection('edw-local-staging') as cursor:
            copy_query = f'COPY {self.table_schema}.{self.table_name} ({", ".join(self.columns)}) FROM STDIN WITH DELIMITER \',\';'
            cursor.cursor.copy_expert(copy_query, StringIteratorIO(row_generator))

    def truncate_previous_test_data(self):
        with DBConnectionFactory().get_connection('edw-local-staging') as cursor:
            cursor.cursor.execute(f'TRUNCATE {self.table_schema}.{self.table_name};')


def make_row_generator(loan_dwid_start: int, loan_dwid_end: int, user_count: int, avg_users_per_loan: int) -> iter:
    return (
        make_row(loan_dwid, user_num)
        for loan_dwid in range(loan_dwid_start, loan_dwid_end + 1)
        for user_num in random.sample(range(1, user_count + 1), avg_users_per_loan)
    )


def make_row(loan_dwid: int, user_num: int) -> str:
    return f'1,2022-01-01,2022-01-01,batch_1,integration_columns,integration_id,2022-01-01,user_{user_num},{loan_dwid},1\n'


# thanks to https://hakibenita.com/fast-load-data-python-postgresql#benchmark
class StringIteratorIO(io.TextIOBase):
    def __init__(self, iter: Iterator[str]):
        self._iter = iter
        self._buff = ''

    def readable(self) -> bool:
        return True

    def _read1(self, n: Optional[int] = None) -> str:
        while not self._buff:
            try:
                self._buff = next(self._iter)
            except StopIteration:
                break
        ret = self._buff[:n]
        self._buff = self._buff[len(ret):]
        return ret

    def read(self, n: Optional[int] = None) -> str:
        line = []
        if n is None or n < 0:
            while True:
                m = self._read1()
                if not m:
                    break
                line.append(m)
        else:
            while n > 0:
                m = self._read1(n)
                if not m:
                    break
                n -= len(m)
                line.append(m)
        return ''.join(line)


if __name__ == '__main__':
    main()
