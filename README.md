# Cautious Unattended Upgrades
Cautious Unattended Upgrades (CUU) is a system for installing Debian `unattended-upgrades` on a test server,
then running a Ruby-based test suite on this test server to ensure that these upgrades have not broken any critical functionality
of your production environment.

If all is well, CUU will 'push' a list of the tested upgrades down to its CUU clients' `unattended-upgrades` package whitelist,
so they will run these upgrades on the next scheduled run.

# Requirements

## CUU Test Server

* `unattended-upgrades` configured to go wild and install all the new (security) updates you desire

## CUU Clients

* `unattended-upgrades` version 0.83 or higher (for Whitelist support) installed and configured
* a cron job to clear the package whitelist after the each execution of `unattended-upgrades`
* a parser limitation at this early stage is that the Whitelist line in `50unattended-upgrades` must be on one line

# Licence

**Copyright (c) 2015, [Van Patten Media Inc.](http://www.vanpattenmedia.com/).**

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Van Patten Media Inc. nor the names of this project's contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

### License Exceptions

Consider any bundled libraries and submodules exceptions to the above. They have their own licenses, which you should follow as appropriate and necessary.

