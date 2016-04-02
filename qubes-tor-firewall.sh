#!/bin/bash
#
# Copyright (c) 2015, Isis Agora Lovecruft <isis@torproject.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

RULESv4=/usr/lib/qubes-tor/rules-v4
RULESv6=/usr/lib/qubes-tor/rules-v6

# function to print error and setup firewall rules to prevent traffic leaks
function error_msg()
{
    echo "qubes-tor: $1" 1>&2
}

function block_everything()
{
    /usr/bin/sudo /sbin/iptables -F
    /usr/bin/sudo /sbin/iptables -P INPUT DROP
    /usr/bin/sudo /sbin/iptables -P OUTPUT DROP
    /usr/bin/sudo /sbin/iptables -P FORWARD DROP
    
    /usr/bin/sudo /sbin/ip6tables -F
    /usr/bin/sudo /sbin/ip6tables -P INPUT DROP
    /usr/bin/sudo /sbin/ip6tables -P OUTPUT DROP
    /usr/bin/sudo /sbin/ip6tables -P FORWARD DROP
}

if [ -f $RULESv4 ] ; then
    /usr/bin/sudo /sbin/iptables-restore < /usr/lib/qubes-tor/rules-v4
    if [ "$?" != 0 ] ; then block_everything ; fi
else
    error_msg "Could not find saved iptables rules in $RULESv4"
    block_everthing
    exit 1
fi

if [ -f $RULESv6 ] ; then
    /usr/bin/sudo /sbin/ip6tables-restore < /usr/lib/qubes-tor/rules-v6
    if [ "$?" != 0 ] ; then block_everything ; fi
else
    error_msg "Could not find saved ip6tables rules in $RULESv6"
    block_everything
    exit 1
fi

exit 0
