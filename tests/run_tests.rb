require 'load_store/load_store'
require 'register_transfer/register_transfer'
require 'stack_ops/stack_ops'
require 'logical/logical'
require 'arithmetic/arithmetic'
require 'incs_decs/incs_decs'
require 'jumps_calls/jumps_calls'

$a_line = 0
$x_line = 1
$y_line = 2
$status_line = 3
$s_line = 4
$stop_line = 5
$m_line = 256 + $stop_line + 1
