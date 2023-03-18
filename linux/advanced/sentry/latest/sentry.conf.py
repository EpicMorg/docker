#############
# LDAP auth #
#############

import ldap
from django_auth_ldap.config import LDAPSearch, GroupOfUniqueNamesType

AUTH_LDAP_SERVER_URI = 'ldap://freeipa.example.com:389'

AUTH_LDAP_BIND_DN = 'krbprincipalname=sentry/freeipa.example.com@EXAMPLE.COM,cn=services,cn=accounts,dc=example,dc=com'

AUTH_LDAP_BIND_PASSWORD = 'qwerty123'

AUTH_LDAP_USER_SEARCH = LDAPSearch(
    'cn=users,cn=accounts,dc=example,dc=com',
    ldap.SCOPE_SUBTREE, '(uid=%(user)s)',
)

AUTH_LDAP_GROUP_SEARCH = LDAPSearch(
    "cn=groups,dc=example,dc=com", ldap.SCOPE_SUBTREE, "(objectClass=groupOfNames)"
)

AUTH_LDAP_GROUP_TYPE = GroupOfUniqueNamesType()
AUTH_LDAP_REQUIRE_GROUP = None
AUTH_LDAP_DENY_GROUP = None

AUTH_LDAP_USER_ATTR_MAP = {
    "first_name": "givenname",
    "last_name": "sn",
    "email": "mail"
}

AUTH_LDAP_FIND_GROUP_PERMS = False
AUTH_LDAP_CACHE_GROUPS = True
AUTH_LDAP_GROUP_CACHE_TIMEOUT = 3600

AUTH_LDAP_DEFAULT_SENTRY_ORGANIZATION = 'Sentry'
AUTH_LDAP_SENTRY_ORGANIZATION_ROLE_TYPE = 'member'
AUTH_LDAP_SENTRY_ORGANIZATION_GLOBAL_ACCESS = True
AUTH_LDAP_SENTRY_SUBSCRIBE_BY_DEFAULT = False

AUTH_LDAP_SENTRY_USERNAME_FIELD = 'cn'
SENTRY_MANAGED_USER_FIELDS = ('email', 'first_name', 'last_name', 'password', )

AUTHENTICATION_BACKENDS = AUTHENTICATION_BACKENDS + (
    'sentry_ldap_auth.backend.SentryLdapBackend',
)

# optional, for debugging
import logging
logger = logging.getLogger('django_auth_ldap')
logger.addHandler(logging.StreamHandler())
logger.addHandler(logging.FileHandler('/var/log/sentry_ldap.log'))
logger.setLevel('DEBUG')

LOGGING['overridable'] = ['sentry', 'django_auth_ldap']
LOGGING['loggers']['django_auth_ldap'] = {
    'handlers': ['console'],
    'level': 'DEBUG'
}
