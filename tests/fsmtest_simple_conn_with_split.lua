--
-- test simple transitions
--

package.path = package.path .. ';../?.lua'

require("rfsm")
require("fsmtesting")
require("utils")

local err = print
local id = 'conn_chain_with_split_test'

conn_chain_split_templ = rfsm.csta:new{
   dummyA = rfsm.sista:new{},
   dummyB = rfsm.sista:new{},

   rfsm.trans:new{ src='initial', tgt='connA1' },
   rfsm.trans:new{ src='connA1', tgt='connA2' },
   rfsm.trans:new{ src='connA2', tgt='dummyA', guard=function () return false end  },

   rfsm.trans:new{ src='initial', tgt='connB1' },
   rfsm.trans:new{ src='connB1', tgt='connB2'},
   rfsm.trans:new{ src='connB2', tgt='dummyB' },

   connA1 = rfsm.conn:new{},
   connA2 = rfsm.conn:new{},
   connB1 = rfsm.conn:new{},
   connB2 = rfsm.conn:new{},
}

test = {
   id = 'simple_conn_split_test',
   pics = true,
   tests = { 
      {
	 descr='testing entry',
	 preact = nil,
	 events = nil,
	 expect = { root={ ['root.dummyB']='done' } }
      }
   }
}


jc = rfsm.init(conn_chain_split_templ)

if not jc then
   print(id .. " initalization failed")
   os.exit(1)
end

if fsmtesting.test_fsm(jc, test) then os.exit(0)
else os.exit(1) end
