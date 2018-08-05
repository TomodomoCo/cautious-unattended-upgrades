# Cautious Unattended Upgrades

**Not in regular use and largely retired!**

Cautious Unattended Upgrades (CUU) is a system for installing Debian `unattended-upgrades` on a test server (the Canary),
then running a Ruby-based test suite on this Canary to ensure that these upgrades have not broken any critical functionality
of your production environment.

If all is well, CUU will 'push' a list of the tested upgrades from the Canary down to its CUU clients' `unattended-upgrades` package whitelist,
so they will run these upgrades on the next scheduled run.

We are using this in conjunction with some Watir/Selenium WebDriver-based browser tests, that verify our deployed websites'
critical functionality has not been broken by one of the unattended upgrades.

**This is a work-in-progress, which *Works For Us*, but is perhaps not fully polished for ease of configuration just yet.** We did
want to get the code out there ASAP, though, and we'll do our best to help if you're having trouble getting things configured.

# Requirements

## CUU Canary Server

* `unattended-upgrades` configured to go wild and install all the new (security) updates you desire
* configured to run the bootstrapper script `run-cuu.rb` daily **after** the `unattended-upgrades` run is finished on the Canary server, and at a time that will not conflict with clients' Whitelist Reset cron job (see below)
* some tests to run (we use Watir/Selenium WebDriver, see `example.test.rb`)
  * if you're using our Watir/Selenium WebDriver tests, the `selenium-webdriver` gem, as well as the `headless` gem, and `Xvfb` and `iceweasel` for the browser itself
  * enough RAM to run a desktop web browser, even in headless mode -- we had to add swap to a 512 MB VM or it was not happy

## CUU Clients

* `unattended-upgrades` version 0.83 or higher (for Whitelist support) installed and configured
* a cron job to clear the package whitelist after the each execution of `unattended-upgrades` (see `cuu-client-configuration-examples/zzzzzz-cuu-whitelistreset.cron.sh`)
* a parser limitation at this early stage is that the Whitelist line in `50unattended-upgrades` must be on one line
* see the `cuu-client-configuration-examples` folder for details on how these are configured

# (Foolish) Assumptions

* We are operating in a Debian 8 (Jessie) environment, and have not tested in any other environment.
* Your test files are written in Ruby, and are assumed to have succeeded unless they raise an exception.

# Known Issues and Desired Improvements

As mentioned, this might start life rather Van Patten Media-opinionated and perhaps a little bit messy and non-Ruby-like. The intention
is to prove the concept, run it for some time to see that it works for us, and then improve this code and its ease of configuration in
a non-VPM environment as time allows.

This is my (Peter Upfold's) first serious Ruby project, and I'll readily acknowledge not doing everything *The Right Way* at this
stage. Please help me if you want to see it be more pretty, and meet Ruby conventions! :)

It has a gemspec, but has not been formally make a "proper" gem at this stage. Maybe eventually it can live on RubyGems.org too.

Pull requests are most welcome -- particularly those that help clean things up, make things clear, and improve the Rubification.
Note that you need to be happy to license your modifications under the licence below if you want them to be included in this repository.
Please include a statement of this intention in your pull request.

Thanks for your interest and for any contributions you make!

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

