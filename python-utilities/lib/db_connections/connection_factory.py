from lib.db_connections.connections import DBConnection, LocalPostgresConnection, LocalMySqlConnection


class DBConnectionFactory:
    """A factory class for building database connections given a string connection name.

    The list of recognized connection names is as follows (the names themselves are self-explanatory):
    - edw-local-config
    - edw-local-ingress
    - edw-local-staging
    - octane-local
    """

    def get_connection(self, connection_name: str) -> DBConnection:
        """Get a database connection object given the connection's name."""
        valid_local_edw_connections = [
            'edw-local-config',
            'edw-local-staging',
            'edw-local-ingress'
        ]

        if connection_name in valid_local_edw_connections:
            return LocalPostgresConnection(dbname=connection_name.split('-')[-1])
        elif connection_name == 'octane-local':
            return LocalMySqlConnection()
        else:
            raise self.InvalidConnectionNameError(connection_name)

    class InvalidConnectionNameError(Exception):
        def __init__(self, connection_name: str):
            super().__init__(f'No connection defined with name "{connection_name}"')
