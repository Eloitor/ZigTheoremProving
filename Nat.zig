const expect = @import("std").testing.expect;

const NatTag = enum {
    zero,
    succ,
};

const Nat = union (NatTag) {
    zero : void,
    succ : *const Nat,

   fn zero() Nat {
       return Nat {.zero = undefined};
   } 
   fn succ(n: Nat) Nat{
       return Nat {.succ = &n};
   }
   fn pred(n: Nat) Nat{
        switch (n) {
           .zero =>  return Nat.zero(),
           .succ =>  |pre| return  pre.*,
       }
   }
   fn is_zero(n: Nat) bool {
       return switch (n){
           zero => True,
           succ => False,
       };
   }
   fn eql(n: Nat, m: Nat) bool {
       switch (n) {
           .zero => |a| switch (m) {
               .zero => return true,
               .succ => return false,
           },
           .succ => switch (m) {
               .zero => return false,
               .succ => return Nat.eql(n.pred(), m.pred()),
           },
       }

   }
   fn add(n: Nat, m: Nat) Nat {
       return switch (n) {
           .zero => m,
           .succ => Nat.succ(Nat.add(n.pred(),m)),
       };

   }
};



test "Naturals" {
    var zero: Nat = Nat.zero();
    // zero == zero
    expect( Nat.eql(zero ,Nat.zero()));
    var one: Nat = Nat.succ(zero);
    // one = succ(zero)
    expect( Nat.eql(one ,Nat.succ(Nat.zero())));
    var two: Nat = Nat.succ(one);
    // one + one == two
    expect( Nat.eql(Nat.add(one,one), two ));
}
