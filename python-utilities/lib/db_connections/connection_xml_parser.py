import re
from xml.dom import minidom

from lib.db_connections.connection_details import ConnectionDetails


def get_connection_details_from_xml_file(file_path: str) -> ConnectionDetails:
    """Construct a ConnectionDetails object from an IntelliJ data source XML file."""
    xml_str = read_xml_file_without_comments(file_path)
    connection_config_document = minidom.parseString(xml_str)
    connection_details = ConnectionDetails()

    # get user name
    username_node = connection_config_document.getElementsByTagName('user-name')[0]
    connection_details.user = username_node.firstChild.data

    # get host, port, and database from connection url
    jdbc_url = connection_config_document.getElementsByTagName('jdbc-url')[0].firstChild.data
    url_match_results = re.match(r'^jdbc:(mysql|postgresql)://([a-zA-Z0-9-.]+):([0-9]+)/([a-zA-Z_]+)$', jdbc_url)
    connection_details.host = url_match_results.group(2)
    connection_details.port = url_match_results.group(3)
    connection_details.database = url_match_results.group(4)

    # get region and credential from additional properties
    jdbc_additional_properties = connection_config_document.getElementsByTagName('jdbc-additional-properties')[0] \
        .getElementsByTagName('property')
    for jdbc_property in jdbc_additional_properties:
        if jdbc_property.attributes['name'].value == 'AWS.RegionId':
            connection_details.region = jdbc_property.attributes['value'].value
        if jdbc_property.attributes['name'].value == 'AWS.CredentialId':
            connection_details.profile_name = jdbc_property.attributes['value'].value.split(':')[1]

    return connection_details


def read_xml_file_without_comments(filepath: str) -> str:
    return ''.join([line for line in open(filepath, 'r') if not re.match(r'^\s*#', line)])
