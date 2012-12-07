Bash startup scripts.

1. .profile

2. .bashrc

   * .bashrc_for_<machine> -- used for stuff specific to a particular machine,
     but which can be kept in this repository
   * .bashrc_local    -- this is sourced if it exists, but not reproduced
     in this repository - i.e., it is stuff that is local to a machine, and
     should not be visible elsewhere.

3. .bash_logout

The Python script __linkup.py can be used to automatically create soft links
from ${HOME} to the various startup scripts.

.. vim: set filetype=rst tabstop=8 softtabstop=2 shiftwidth=2 expandtab:
