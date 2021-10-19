from typing import List

from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


class StagingOctaneMetadataBuilder:

    def __init__(self, column_metadata: List[dict], foreign_key_metadata: List[dict]):
        self._column_metadata = column_metadata
        self._foreign_key_metadata = foreign_key_metadata

    def build_metadata(self) -> DataWarehouseMetadata:
        tables_dict = {}
        for row in self._column_metadata:
            if row['table_name'] not in tables_dict:
                tables_dict[row['table_name']] = {
                    'name': row['table_name'],
                    'primary_key': [],
                    'foreign_keys': {},
                    'columns': {}
                }
            if row['is_primary_key'] == 1:
                tables_dict[row['table_name']]['primary_key'].append(row['column_name'])
            tables_dict[row['table_name']]['columns'][row['column_name']] = {
                'data_type': self.map_data_type(row['column_type'])
            }

        for row in self._foreign_key_metadata:
            tables_dict[row['table_name']]['foreign_keys'][row['constraint_name']] = {
                'columns': [row['column_name']],
                'references': {
                    'columns': [row['referenced_column_name']],
                    'schema': 'staging_octane',
                    'table': row['referenced_table_name']
                }
            }

        metadata_dict = {
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': tables_dict.values()
                        }
                    ]
                }
            ]
        }
        return construct_data_warehouse_metadata_from_dict(metadata_dict)

    @staticmethod
    def map_data_type(data_type: str) -> str:
        upper_data_type = data_type.upper()
        if upper_data_type == 'DATE' or upper_data_type == 'TIME' or upper_data_type == 'TEXT' or upper_data_type.startswith('VARCHAR('):
            return upper_data_type
        elif upper_data_type == 'DATETIME':
            return 'TIMESTAMP'
        elif upper_data_type.startswith('TINYINT('):
            return 'SMALLINT'
        elif upper_data_type.startswith('INT('):
            return 'INTEGER'
        elif upper_data_type.startswith('BIGINT('):
            return 'BIGINT'
        elif upper_data_type.startswith('BIT('):
            return 'BOOLEAN'
        elif upper_data_type.startswith('DECIMAL('):
            return f'NUMERIC{upper_data_type[7:]}'
        else:
            raise ValueError(f'Unable to map data type {upper_data_type}')
