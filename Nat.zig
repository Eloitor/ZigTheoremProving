const expect = @import("std").testing.expect;

/// A natural is either zero or the successor of a natural.
const NatTag = enum {
    zero,
    succ,
};
pub const Nat = union (NatTag) {
    zero : void,
    succ : *const Nat,

   /// Constructors
   pub const zero = Nat {.zero = undefined};
   pub fn succ(n: Nat) Nat{
       return Nat {.succ = &n};
   }

   pub fn pred(n: Nat) Nat{
        switch (n) {
           .zero =>  return Nat.zero,
           .succ =>  |pre| return  pre.*,
       }
   }
   pub fn is_zero(n: Nat) bool {
       return switch (n){
           zero => true,
           succ => false,
       };
   }
   pub fn eql(n: Nat, m: Nat) bool {
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
    var zero: Nat = Nat.zero;
    // zero == zero
    expect( Nat.eql(zero ,Nat.zero));
    var one: Nat = Nat.succ(zero);
    // one = succ(zero)
    expect( Nat.eql(one ,Nat.succ(Nat.zero)));
    var two: Nat = Nat.succ(one);
    // one + one == two
    expect( Nat.eql(Nat.add(one,one), two ));
}
