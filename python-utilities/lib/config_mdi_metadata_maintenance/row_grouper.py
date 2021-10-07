from typing import List
from abc import ABC, abstractmethod
from lib.config_mdi_metadata_maintenance.metadata_table import Row


class RowGrouper(ABC):

    @abstractmethod
    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
        pass


class DefaultRowGrouper(RowGrouper):

    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
        return [rows]
