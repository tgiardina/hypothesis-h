# -*- coding: utf-8 -*-

from h.nipsa import models
from h.nipsa import worker


def index():
    """Return a list of all the NIPSA'd user IDs.

    :rtype: list of unicode strings

    """
    return [nipsa_user.userid for nipsa_user in models.NipsaUser.all()]


def add_nipsa(request, userid):
    """NIPSA a user.

    Add the given user's ID to the list of NIPSA'd user IDs.
    If the user is already NIPSA'd then nothing will happen (but an "add_nipsa"
    message for the user will still be published to the queue).

    """
    nipsa_user = models.NipsaUser.get_by_userid(userid)
    if not nipsa_user:
        nipsa_user = models.NipsaUser(userid)
        request.db.add(nipsa_user)

    worker.add_nipsa.delay(userid)


def remove_nipsa(request, userid):
    """Un-NIPSA a user.

    If the user isn't NIPSA'd then nothing will happen (but a "remove_nipsa"
    message for the user will still be published to the queue).

    """
    nipsa_user = models.NipsaUser.get_by_userid(userid)
    if nipsa_user:
        request.db.delete(nipsa_user)

    worker.remove_nipsa.delay(userid)


def has_nipsa(userid):
    """Return True if the given user is on the NIPSA list, False if not."""
    return models.NipsaUser.get_by_userid(userid) is not None
