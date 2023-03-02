# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Param (
    [Parameter(Position=1)] [String]$server,
    [Parameter(Position=2)] [String]$username,
    [Parameter(Position=3)] [String]$password,
    [Parameter(Position=4)] [String]$name
)

Connect-VIServer -Server "$server" -User "$username" -Password "$password"
$vm = Get-VM "$name"
$vm.ExtensionData.UnregisterVM()
Disconnect-VIServer * -Confirm:$false
