////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public final class BigUintTest {

		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------
		
		Parameterized;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const domain:ApplicationDomain = ApplicationDomain.currentDomain;

		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------

		[Before]
		public function beforeTest():void {
			var len:uint = 1 << 16;
			var mem:ByteArray = new ByteArray();
			// сейчайс заполним тут всё говницом
			mem.writeInt( 0x12345678 );
			do {
				mem.writeBytes( mem, 0, mem.position );
			} while ( mem.position < len );
			domain.domainMemory = mem;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  testBit
		//----------------------------------

		public static var $testBit:Array = [
			[ '0', 1, false ],
			[ '123', 40, false ],
			[ '123F77F1F3F5F', 32, true ],
			[ '123F77F1F3F5F', 31, false ]
		];

		[Test( order="1", dataProvider="$testBit" )]
		public function testBit(v:String, n:uint, result:Boolean):void {
			var R:Boolean = BigUintStr.testBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ' + '( 1 << ' + n + ' ) != 0',
				R, result
			);
		}

		//----------------------------------
		//  setBit
		//----------------------------------

		public static var $setBit:Array = [
			[ '987654321', 9, '987654321' ],
			[ 'FFFFFFFF111111', 256,	'100000000000000000000000000000000000000000000000000FFFFFFFF111111' ],
			[ '12345678', 2, '1234567C' ]
		];

		[Test( order="2", dataProvider="$setBit" )]
		public function setBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.setBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ' + '( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  clearBit
		//----------------------------------

		public static var $clearBit:Array = [
			[ '0', 12, '0' ],
			[ '123', 90, '123' ],
			[ '123', 3, '123' ],
			[ '10000000123', 40, '123' ],
			[ '123', 8, '23' ]
		];

		[Test( order="3", dataProvider="$clearBit" )]
		public function clearBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.clearBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ~( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  flipBit
		//----------------------------------

		public static var $flipBit:Array = [
			[ '100000000000123', 56, '123' ],
			[ '123', 56, '100000000000123' ],
			[ '12b', 3, '123' ]
		];

		[Test( order="4", dataProvider="$flipBit" )]
		public function flipBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.flipBit( v, n );
			Assert.assertEquals(
				'( 0x' + v.toLowerCase() + ' ^ ( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  not
		//----------------------------------

		public static var $not:Array = [
			[ '0', '0' ],
			[ 'FF00FF00FF00FF00', 'FF00FF00FF00FF' ]
		];

		[Test( order="5", dataProvider="$not" )]
		public function not(v:String, result:String):void {
			var R:String = BigUintStr.not( v );
			Assert.assertEquals(
				'~0x' + v.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  and
		//----------------------------------

		public static var $and:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '9012345678', 'FFFFFF0000000912345678', '12345678' ]
		];

		[Test( order="6", dataProvider="$and" )]
		public function and(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.and( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' & 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  andNot
		//----------------------------------

		public static var $andNot:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '123' ],
			[ '123', 'FFF', '0' ],
			[ 'FFFF00FF00', 'EE00', 'FFFF001100' ],
			[ '12345678FFFF00FF00', 'EE00', '12345678FFFF001100' ]
		];

		[Test( order="7", dataProvider="$andNot" )]
		public function andNot(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.andNot( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' & ~0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  or
		//----------------------------------

		public static var $or:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '654321', '123F77FFF0FF6', '123F77FFF4FF7' ],
			[ 'FFFFFF123F77FFF0FF6', '654321', 'FFFFFF123F77FFF4FF7' ]
		];

		[Test( order="8", dataProvider="$or" )]
		public function or(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.or( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' | 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  xor
		//----------------------------------

		public static var $xor:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '123F77FFFFFF6', '654321', '123F77F9ABCD7' ],
			[ 'FFFFFFFF123F77FFFFFF6', '654321', 'FFFFFFFF123F77F9ABCD7' ]
		];

		[Test( order="9", dataProvider="$xor" )]
		public function xor(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.xor( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' ^ 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  shiftRight
		//----------------------------------

		public static var $shiftRight:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ 'FFFFFFFF', 32, '0' ],
			[ '123FFFFFFFF', 32, '123' ],
			[ '12345678FFFFFFFF', 8, '12345678FFFFFF' ],
			[ '12345678FFFFFFFF', 33, '91A2B3C' ]
		];

		[Test( order="10", dataProvider="$shiftRight" )]
		public function shiftRight(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.shiftRight( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' >> ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  shiftLeft
		//----------------------------------

		public static var $shiftLeft:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ '12', 123, '90000000000000000000000000000000' ],
			[ '123456', 24, '123456000000' ],
			[ '1234567890', 17, '2468ACF1200000' ],
			[ '1234567890', 26, '48D159E240000000' ]
		];

		[Test( order="11", dataProvider="$shiftLeft" )]
		public function shiftLeft(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.shiftLeft( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' << ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  compare
		//----------------------------------

		public static var $compare:Array = [
			[ '123', '0', 1 ],
			[ '0', '123', -1 ],
			[ '987654321', '123456789', 1 ],
			[ '123456789', '987654321', -1 ],
			[ 'F87654321', 'F23456789', 1 ],
			[ 'F23456789', 'F87654321', -1 ],
			[ '123', '123', 0 ]
		];

		[Test( order="12", dataProvider="$compare" )]
		public function compare(v1:String, v2:String, result:int):void {
			var F:Function = function(R:int):String {
				if ( R == 1 ) return '>';
				else if ( R == -1 ) return '<';
				else return '==';
			}
			var R:int = BigUintStr.compare( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' ' + F( R ) + ' 0x' + v2.toLowerCase(),
				R, result
			);
		}

		//----------------------------------
		//  increment
		//----------------------------------

		public static var $increment:Array = [
			[ '0', '1' ],
			[ '123', '124' ],
			[ 'FFFFFFFF', '100000000' ],
			[ '123456780000000F', '1234567800000010' ],
			[ 'FF123456780000000F', 'FF1234567800000010' ]
		];

		[Test( order="13", dataProvider="$increment" )]
		public function increment(v:String, result:String):void {
			var R:String = BigUintStr.increment( v );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + '++',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  add
		//----------------------------------

		public static var $add:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '123456', '123', '123579' ],
			[ '654321', '11111234567812345678FFFFFFFFFFFFFFFF', '111112345678123456790000000000654320' ],
			[ '654321', 'FFFFFFFFFFFFFFFF', '10000000000654320' ]
		];

		[Test( order="14", dataProvider="$add" )]
		public function add(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.add( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' + 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  decrement
		//----------------------------------

		public static var $decrement:Array = [
			[ '123', '122' ],
			[ '12300000000', '122FFFFFFFF' ],
			[ 'FFFFFFFF12300000000', 'FFFFFFFF122FFFFFFFF' ]
		];

		[Test( order="15", dataProvider="$decrement" )]
		public function decrement(v1:String, result:String):void {
			var R:String = BigUintStr.decrement( v1 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + '--',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  decrement_error
		//----------------------------------

		public static var $decrement_error:Array = [
			[ '0' ]
		];

		[Test( order="16", dataProvider="$decrement_error", expects="ArgumentError" )]
		public function decrement_error(v1:String):void {
			BigUintStr.decrement( v1 );
		}

		//----------------------------------
		//  sub
		//----------------------------------

		public static var $sub:Array = [
			[ '123', '0', '123' ],
			[ '123', '123', '0' ],
			[ '123', '12', '111' ],
			[ 'FF0000000000000123', 'FFFF', 'FEFFFFFFFFFFFF0124' ],
			[ 'FF0000000000000123', '122', 'FF0000000000000001' ],
			[ 'FF00000123', '122', 'FF00000001' ]
		];

		[Test( order="17", dataProvider="$sub" )]
		public function sub(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.sub( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' - 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  sub_error
		//----------------------------------

		public static var $sub_error:Array = [
			[ '0', '123' ],
			[ '12', '123' ],
			[ '123', '123FFFFFFFF' ],
			[ '1200000000', '2100000000' ]
		];

		[Test( order="18", dataProvider="$sub_error", expects="ArgumentError" )]
		public function sub_error(v1:String, v2:String):void {
			BigUintStr.sub( v1, v2 );
		}

		//----------------------------------
		//  mult
		//----------------------------------

		public static var $mult:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '1', '123456', '123456' ],
			[ '123456', '1', '123456' ],
			[ '400000000', '100', '40000000000' ],
			[ '400000000', '3', 'C00000000' ],
			[ '3', '400000000', 'C00000000' ],
			[ '123', '12', '1476' ],
			[ '123F77FFFFFF6', '13', '15AB5E7FFFFF42' ],
			[ '13', '123F77FFFFFF6', '15AB5E7FFFFF42' ],
			[ 'FFFF0000', '11110000', '1110EEEF00000000' ],
			[ 'FFFF1111', '11110000', '1110F01243210000' ],
			[ '6FFFFFF77F321', '123F77FFFFFF6', '7fbc47f64d5901167855080b6' ],
			[ 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'fffffffffffffffffffffffffffffffe00000000000000000000000000000001' ]
		];

		[Test( order="19", dataProvider="$mult" )]
		public function mult(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.mult( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' * 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  powInt
		//----------------------------------
		
		public static var $powInt:Array = [
			[ '123', 0, '1' ],
			[ '0', 5, '0' ],
			[ '123', 1, '123' ],
			[ 'FFFFF', 6, 'ffffa0000efffec0000effffa00001' ],
			[ '3', 0xFF, '11f1b08e87ec42c5d83c3218fc83c41dcfd9f4428f4f92af1aaa80aa46162b1f71e981273601f4ad1dd4709b5aca650265a6ab' ],
			[ 'F00', 77, '1c744e6621724dba25aea0207a6c11c8a22b3801df5b01f8658653f5f67a653a1c09c70576cf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ]
		];
		
		[Test( order="20", dataProvider="$powInt" )]
		public function powInt(v1:String, e:uint, result:String):void {
			var R:String = BigUintStr.powInt( v1, e );
			Assert.assertEquals(
				'pow( 0x' + v1.toLowerCase() + ', ' + e + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  divAndMod
		//----------------------------------

		public static var $divAndMod:Array = [
			[ '1234', '123456789', '0', '1234' ],
			[ '123456789', '1', '123456789', '0' ],
			[ '123', '123', '1', '0' ],
			[ '12', '123', '0', '12' ],
			[ '6F9', '7', 'FF', '0' ],
			[ '14EB', '8', '29D', '3' ],
			[ '123456789', '3', '61172283', '0' ],
			[ '123456789', '7', '299C335C', '5' ],
			[ '1234567890FFFFFFFF', '1234567890', '100000000', 'FFFFFFFF' ]
		];

		[Test( order="21", dataProvider="$divAndMod" )]
		public function divAndMod(v1:String, v2:String, result:String, rest:String):void {
			var R:Array = BigUintStr.divAndMod( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' / 0x' + v2.toLowerCase(),
				R.join( ',' ).toString().toLowerCase(), [ result, rest ].join( ',' ).toLowerCase()
			);
		}

		public static function $divAndMod_long1():Array {
			var result:Array = new Array();
			for ( var i:Number = 0xFFFFFFFF; i<0x100FFFFFFFF; i += 0xFFFFFFFF ) {
				for ( var j:Number = 0xFFFFFFFF; j<0x100FFFFFFFF; j += 0xFFFFFFFFF ) {
					result.push( [ i.toString( 16 ), j.toString( 16 ) ] );
				}
			}
			return result;
		}

		[Test( order="22", dataProvider="$divAndMod_long1" )]
		public function divAndMod_long1(v1:String, v2:String):void {
			var o:Object = getDefinitionByName( 'com.hurlant.math.BigInteger' );
			var R:Array = BigUintStr.divAndMod( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' / 0x' + v2.toLowerCase(),
				R.join( ',' ).toString().toLowerCase(), ( new o( v1, 16, true ) ).divideAndRemainder( new o( v2, 16, true ) ).join( ',' ).toLowerCase()
			);
		}
		
//		//----------------------------------
//		//  divAndMod_error
//		//----------------------------------
//
//		public static var $divAndMod_error:Array = [
//			[ '123456', '0' ]
//		];
//
//		[Test( order="22", dataProvider="$divAndMod_error", expects="ArgumentError" )]
//		public function divAndMod_error(v1:String, v2:String):void {
//			BigUintStr.divAndMod( v1, v2 );
//		}

//		//----------------------------------
//		//  div
//		//----------------------------------
//
//		[Test]
//		public static var $div:Array = [
//			[ '0', '123', '0' ],
//			[ '0', '123456', '0' ],
//			[ '123', '12', '10' ],
//			[ '12', '123', '0' ],
//			[ '123', '123', '1' ],
//			[ '123456', '123', '1003' ],
//			[ '123', '123456', '0' ],
//			[ '654321', '123456', '5' ],
//			[ '123456', '654321', '0' ],
//			[ '123F77FFFFFF6', '654321', '2E21E49' ],
//			[ '3DD803668', '51F11', 'C135' ]
//		];
//
//		[Test( order="23", dataProvider="$div" )]
//		public function div(v1:String, v2:String, result:String):void {
//			var R:String = BigUintStr.div( v1, v2 );
//			Assert.assertEquals(
//				'0x' + v1.toLowerCase() + ' / 0x' + v2.toLowerCase(),
//				R.toLowerCase(), result.toLowerCase()
//			);
//		}
//
//		//----------------------------------
//		//  div_error
//		//----------------------------------
//
//		public static var $div_error:Array = [
//			[ '123456', '0' ]
//		];
//
//		[Test( order="24", dataProvider="$div_error", expects="ArgumentError" )]
//		public function div_error(v1:String, v2:String):void {
//			BigUintStr.div( v1, v2 );
//		}
//
//		//----------------------------------
//		//  mod
//		//----------------------------------
//
//		public static var $mod:Array = [
//			[ '0', '123', '0' ],
//			[ '0', '123456', '0' ],
//			[ '123', '12', '3' ],
//			[ '12', '123', '12' ],
//			[ '123', '123', '0' ],
//			[ '123456', '123', 'ED' ],
//			[ '123', '123456', '123' ],
//			[ '654321', '123456', 'A3D73' ],
//			[ '123456', '654321', '123456' ],
//			[ '123F77FFFFFF6', '654321', '1FFD8D' ],
//			[ '123F77FFFFFF6', '1F11', 'EA2' ],
//			[ '3DD803668', '51F11', '4F6E3' ]
//		];
//
//		[Test( order="25", dataProvider="$mod" )]
//		public function mod(v1:String, v2:String, result:String):void {
//			var R:String = BigUintStr.mod( v1, v2 );
//			Assert.assertEquals(
//				'0x' + v1.toLowerCase() + ' % 0x' + v2.toLowerCase(),
//				R.toLowerCase(), result.toLowerCase()
//			);
//		}
//
//		//----------------------------------
//		//  mod_error
//		//----------------------------------
//
//		public static var $mod_error:Array = [
//			[ '123456', '0' ]
//		];
//
//		[Test( order="26", dataProvider="$mod_error", expects="ArgumentError" )]
//		public function mod_error(v1:String, v2:String):void {
//			BigUintStr.mod( v1, v2 );
//		}
//
		//----------------------------------
		//  modPowInt
		//----------------------------------

//		public function modPowInt(v1:String, e:uint, v2:String, result:String):void {
//			reset();
//			var R:String = BigUintStr.modPowInt( v1, e, v2 );
//			trace(
//				'pow( 0x' + v1.toLowerCase() + ', ' +
//				e + ' ) % ' +
//				'0x' + v2.toLowerCase() + ' = ' +
//				'0x' + R.toLowerCase() +
//				( R.toLowerCase() != result.toLowerCase() ? ' ==========> ( ' + result.toLowerCase() + ' )' : '' )
//			);
//		}

	}

}