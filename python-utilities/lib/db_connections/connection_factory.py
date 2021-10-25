import os

from lib.db_connections.connections import DBConnection, AWSPostgresConnection, AWSMySQLConnection, LocalPostgresConnection
from lib.db_connections.connection_xml_parser import get_connection_details_from_xml_file

# default location for data sources in the /settings/data-sources dir in the data-warehouse repo
default_data_sources_dir_path = os.path.abspath(os.path.join(
    os.path.dirname(os.path.realpath(__file__)),
    '..',
    '..',
    '..',
    'settings',
    'data-sources'
))


class DBConnectionFactory:
    """A factory class for building database connections given a string connection name.

    The list of recognized connection names is as follows (the names themselves are self-explanatory):
    - edw-local-config
    - edw-local-ingress
    - edw-local-staging
    - octane-cert
    """

    def __init__(self, data_sources_dir_path: str = default_data_sources_dir_path):
        self._data_sources_dir_path = data_sources_dir_path

    def get_connection(self, connection_name: str, ssl_ca_filepath: str = None) -> DBConnection:
        """Get a database connection object given the connection's name.

        An AWS SSL certificate filepath is required for AWS database connections.
        The required certificate file can be downloaded from the below URL, provided
        your computer has previously been authenticated through AWS SSO.

        https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
        """
        if connection_name == 'octane-cert':
            return self._make_octane_connection(connection_name, ssl_ca_filepath)
        elif connection_name == 'edw-local-config':
            return LocalPostgresConnection(dbname='config')
        elif connection_name == 'edw-local-staging':
            return LocalPostgresConnection(dbname='staging')
        elif connection_name == 'edw-local-ingress':
            return LocalPostgresConnection(dbname='ingress')
        else:
            raise self.InvalidConnectionNameError(connection_name)

    def _make_octane_connection(self, connection_name: str, ssl_ca_filepath: str) -> AWSMySQLConnection:
        if not ssl_ca_filepath or not os.path.isfile(ssl_ca_filepath):
            raise FileNotFoundError(f'Invalid ssl certificate file path: "{ssl_ca_filepath}"')
        connection_details = get_connection_details_from_xml_file(self._make_xml_file_path(f'{connection_name}-data-source.xml'))
        return AWSMySQLConnection(connection_details, ssl_ca_filepath)

    def _make_xml_file_path(self, file_name: str) -> str:
        return os.path.join(self._data_sources_dir_path, file_name)

    class InvalidConnectionNameError(Exception):
        def __init__(self, connection_name: str):
            super().__init__(f'No connection defined with name "{connection_name}"')
