package com.viburnum.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ViburnumMouseEvent extends Event
	{
		public static const BUTTON_DOWN:String = "buttonDown";
		
		//从mouseDown开始到mouseUp之间所有发生的鼠标事件
		public static const BUTTON_ROLL_OVER:String = "buttonRollOver";
		public static const BUTTON_ROLL_OUT:String = "buttonRollOut";

		public static const BUTTON_HOLD_MOVE:String = "buttonHoldMove";
		public static const BUTTON_HOLD_RELEASE:String = "buttonHoldRelease";
		
		//mouseDown的捕获阶段触发
		public static const POPUP_CHILD_MOUSE_DOWN_OUTSIDE:String = "popupChildMouseDownOutSide";

		public var deltaX:Number = 0;
		public var deltaY:Number = 0;
		
		public var relatedObject:InteractiveObject = null;

		private var _localX:Number = 0;
		private var _localY:Number = 0;
		
		private var _stageX:Number = 0;
		private var _stageY:Number = 0;
		
		private var _ctrlKey:Boolean = false;
		private var _altKey:Boolean = false;
		private var _shiftKey:Boolean = false;
		
		private var _isHoldTarget:Boolean = false;
		private var _isOnTarget:Boolean = false;

		public function ViburnumMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
										   localX:Number = 0, localY:Number = 0,
										   stageX:Number = 0, stageY:Number = 0,
										   ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
										   isHoldTarget:Boolean = false,
										   isOnTarget:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_localX = localX;
			_localY = localY;
			
			_stageX = stageX;
			_stageY = stageY;
			
			_ctrlKey = ctrlKey;
			_altKey = altKey;
			_shiftKey = shiftKey;
			
			_isHoldTarget = isHoldTarget;
			_isOnTarget = isOnTarget;
		}
		
		public function get localX():Number
		{
			return _localX;
		}
		
		public function get localY():Number
		{
			return _localY;
		}
		
		public function get stageX():Number
		{
			return _stageX;
		}
		
		public function get stageY():Number
		{
			return _stageY;
		}
		
		public function get ctrlKey():Boolean
		{
			return _ctrlKey;
		}
		
		public function get altKey():Boolean
		{
			return _altKey;
		}
		
		public function get shiftKey():Boolean
		{
			return _shiftKey;
		}
		
		public function get isHoldTarget():Boolean
		{
			return _isHoldTarget;
		}
		
		public function get isOnTarget():Boolean
		{
			return _isOnTarget;
		}
		
		override public function clone():Event
		{
			var event:ViburnumMouseEvent = new ViburnumMouseEvent(type, bubbles, cancelable, 
																	localX, localY,
																	stageX, stageY,
																	ctrlKey, altKey, shiftKey,
																	isHoldTarget,
																	isOnTarget);
			event.deltaX = this.deltaX;
			event.deltaY = this.deltaY;
			
			event.relatedObject = this.relatedObject;

			return event;
		}
	}
}