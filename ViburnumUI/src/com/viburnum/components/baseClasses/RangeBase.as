package com.viburnum.components.baseClasses
{
    import com.viburnum.components.SkinableComponent;
    import com.viburnum.events.ViburnumEvent;

	[Event(name="valueChanged", type="com.viburnum.events.ViburnumEvent")]
	
    public class RangeBase extends SkinableComponent
    {
		private var _maximum:Number = 100;
		private var _maxChangedFlag:Boolean = false;

		private var _minimum:Number = 0;
		private var _minChangedFlag:Boolean = false;

		private var _stepSize:Number = 1;
		private var _stepSizeChangedFlag:Boolean = false;

		private var _value:Number = 0;
		private var _changedValue:Number = 0;
		private var _valueChangedFlag:Boolean = false;

		private var _snapInterval:Number = 1;
		private var _snapIntervalChangedFlag:Boolean = false;
		private var _explicitSnapInterval:Boolean = false;

		public function RangeBase()
        {
            super();
        }

		public function changeValueByStep(increase:Boolean = true):void
		{
			if(_stepSize == 0) return;

			var newValue:Number = increase ? value + _stepSize : value - _stepSize;
			setValue(nearestValidValue(newValue, _snapInterval));
		}
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		[Inspectable(type="Number", defaultValue="100")]
		public function set maximum(value:Number):void
		{
			if(value < _minimum) value = _minimum;
			
			if(_maximum == value) return;
			
			_maximum = value;
			_maxChangedFlag = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		[Inspectable(type="Number", defaultValue="0")]
		public function set minimum(value:Number):void
		{
			if(value > _maximum) value = _maximum;

			if(_minimum == value) return;

			_minimum = value;
			_minChangedFlag = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		[Inspectable(type="Number", defaultValue="1")]
		public function set stepSize(value:Number):void
		{
			if(_stepSize != value)
			{
				_stepSize = value;
				_stepSizeChangedFlag = true;
				
				invalidateProperties();
			}
		}
		
		public function get value():Number
		{
			return (_valueChangedFlag) ? _changedValue : _value;
		}
		
		[Inspectable(type="Number", defaultValue="0")]
		public function set value(newValue:Number):void
		{
			if(newValue != this.value)
			{
				_changedValue = newValue;

				_valueChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		
		[Inspectable(type="Number", defaultValue="1")]
		public function set snapInterval(value:Number):void
		{
			// snapInterval defaults to stepSize if snapInterval is not
			// explicitly set.
			_explicitSnapInterval = true;

			if(_snapInterval != value)
			{
				// NaN effectively clears the snapInterval and resets it to 1.
				if (isNaN(value))
				{
					_snapInterval = 1;
					_explicitSnapInterval = false;
				}
				else
				{
					_snapInterval = value;
				}
				
				_snapIntervalChangedFlag = true;
				_stepSizeChangedFlag = true;
				
				invalidateProperties();
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_valueChangedFlag || _maxChangedFlag || _minChangedFlag || _snapIntervalChangedFlag)
			{
				var currentValue:Number = value;
				
				_valueChangedFlag = false;
				_maxChangedFlag = false;
				_minChangedFlag = false;
				_snapIntervalChangedFlag = false;
				
				setValue(nearestValidValue(currentValue, snapInterval));
			}
			
			if(_stepSizeChangedFlag)
			{
				_stepSizeChangedFlag = false;
				// Only modify stepSize if snapInterval was explicitly set.
				// Otherwise, snapInterval defaults to stepSize and we set
				// the value to respect the new snapInterval.
				if(_explicitSnapInterval)
				{
					_stepSize = nearestValidSize(_stepSize);
				}
				else
				{
					_snapInterval = _stepSize;
					setValue(nearestValidValue(_value, snapInterval));
				}
			}
		}

		protected function nearestValidSize(size:Number):Number
		{
			var interval:Number = snapInterval;
			if (interval == 0) return size;
			
			var validSize:Number = Math.round(size / interval) * interval
			return (Math.abs(validSize) < interval) ? interval : validSize;
		}

		protected function nearestValidValue(value:Number, interval:Number):Number
		{
			if(interval == 0) return Math.max(minimum, Math.min(maximum, value));
			
			var maxValue:Number = maximum - minimum;
			var scale:Number = 1;
			
			value -= minimum;
			
			// If interval isn't an integer, there's a possibility that the floating point 
			// approximation of value or value/interval will be slightly larger or smaller 
			// than the real value.  This can lead to errors in calculations like 
			// floor(value/interval)*interval, which one might expect to just equal value, 
			// when value is an exact multiple of interval.  Not so if value=0.58 and 
			// interval=0.01, in that case the calculation yields 0.57!  To avoid problems, 
			// we scale by the implicit precision of the interval and then round.  For 
			// example if interval=0.01, then we scale by 100.    
			if(interval != Math.round(interval)) 
			{ 
				const parts:Array = (new String(1 + interval)).split("."); 
				scale = Math.pow(10, parts[1].length);
				maxValue *= scale;
				value = Math.round(value * scale);
				interval = Math.round(interval * scale);
			}   
			
			var lower:Number = Math.max(0, Math.floor(value / interval) * interval);
			var upper:Number = Math.min(maxValue, Math.floor((value + interval) / interval) * interval);
			var validValue:Number = ((value - lower) >= ((upper - lower) / 2)) ? upper : lower;

			return (validValue / scale) + minimum;
		}

		protected function setValue(value:Number):void
		{
			if(_value == value) return;

			if(!isNaN(maximum) && !isNaN(minimum) && (maximum > minimum))
			{
				_value = Math.min(maximum, Math.max(minimum, value));
			}
			else
			{
				_value = value;
			}
			
			invalidateDisplayList();

			if(hasEventListener(ViburnumEvent.VALUE_CHANGED))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.VALUE_CHANGED));
			}
		}
    }
}