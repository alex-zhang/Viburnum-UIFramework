package com.viburnum.components.baseClasses
{
	import com.viburnum.components.StateName;
	import com.viburnum.core.viburnum_internal;
	import com.viburnum.events.ViburnumMouseEvent;
	import com.viburnum.utils.LayoutUtil;
	import com.viburnum.utils.UpdateAfterEventGloabalControlUtil;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	use namespace viburnum_internal;

	[Event(name="buttonDown", type="com.viburnum.events.ViburnumMouseEvent")]
	
	include "../../style/styleMetadata/StatedBackgroundStyle.as";
	include "../../style/styleMetadata/StatedIconStyle.as";
	include "../../style/styleMetadata/PaddingStyle.as";
	
	[Style(name="repeatInterval", type="Number", format="Time", minValue="0.0")]

    public class ButtonBase extends BorderComponentBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				//StatedBackgroundStyle
				{name:"backgroundSkin", type:"Class", skinClass:"true"},
				{name:"backgroundSkin_upSkin", type:"Class"},
				{name:"backgroundSkin_overSkin", type:"Class"},
				{name:"backgroundSkin_downSkin", type:"Class"},
				{name:"backgroundSkin_disabledSkin", type:"Class"},
				
				//StatedIconStyle
				{name:"iconSkin", type:"Class", skinClass:"true"},
				{name:"iconSkin_upSkin", type:"Class"},
				{name:"iconSkin_overSkin", type:"Class"},
				{name:"iconSkin_downSkin", type:"Class"},
				{name:"iconSkin_disabledSkin", type:"Class"},
				
				//PaddingStyle
				{name:"paddingLeft", type:"Number"},
				{name:"paddingTop", type:"Number"},
				{name:"paddingRight", type:"Number"},
				{name:"paddingBottom", type:"Number"},
				
				{name:"repeatInterval", type:"Number", format:"Time", minValue:"0.0"},
			]
		}
		
		//--
		
		public var backgroundSkin:DisplayObject;
		public var iconSkin:DisplayObject;

		private var _autoRepeat:Boolean = false;
		private var _autoRepeatTimer:Timer;
		
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		private var _isKeyboardPressed:Boolean = false;
		
		private var _mouseDownGlobalPoint:Point;

        public function ButtonBase()
        {
            super();

			mouseChildren = false;
			
			currentState = StateName.UP;
        }
		
		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}

		[Inspectable(type="Boolean", defaultValue="false")]
		public function set autoRepeat(value:Boolean):void
		{
			_autoRepeat = value;
		}
		
		override public function set enabled(value:Boolean):void
		{
			if(super.enabled == value) return;
			
			super.enabled = value;
			
			currentState = getCurrentSkinState();
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.sortDisplayObjectChildren(this, iconSkin, backgroundSkin, borderSkin);
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var backgroundWidth:Number = layoutWidth - bl - br;
			var backgroundHeight:Number = layoutHeight - bt - bb;
			
			LayoutUtil.setDisplayObjectLayout(backgroundSkin, bl, bt, backgroundWidth, backgroundHeight);
		}

		//event Handler
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			
			keyboardPressed = false;
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			if(!_isMouseDown) return;

			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_HOLD_MOVE))
			{
				var evt:ViburnumMouseEvent = new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_HOLD_MOVE, false, false, 
					event.localX, event.localY, event.stageX, event.stageY, 
					event.ctrlKey, event.altKey, event.shiftKey, _isMouseDown, _isMouseOver);
				evt.deltaX = event.stageX - _mouseDownGlobalPoint.x;
				evt.deltaY = event.stageY - _mouseDownGlobalPoint.y;
				dispatchEvent(evt);
			}
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}

		private function stageMouseUpHandler(event:MouseEvent):void
		{
			if(!_isMouseDown) return;

			_isMouseDown = false;

			currentState = getCurrentSkinState();

			checkAutoRepeatTimerConditions();

			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);

			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_HOLD_RELEASE))
			{
				var evt:ViburnumMouseEvent = new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_HOLD_RELEASE, false, false, 
					event.localX, event.localY, event.stageX, event.stageY, 
					event.ctrlKey, event.altKey, event.shiftKey, _isMouseDown, _isMouseOver);
				evt.deltaX = event.stageX - _mouseDownGlobalPoint.x;
				evt.deltaY = event.stageY - _mouseDownGlobalPoint.y;
				dispatchEvent(evt);
			}

			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(!enabled)
            {
                event.stopImmediatePropagation();
                return;
            }

			if(event.buttonDown && !getIsButtonDown()) return;

			_isMouseOver = true;
			
			currentState = getCurrentSkinState();
			
			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_ROLL_OVER))
			{
				var evt:ViburnumMouseEvent = new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_ROLL_OVER, false, false, 
					event.localX, event.localY, event.stageX, event.stageY, 
					event.ctrlKey, event.altKey, event.shiftKey, _isMouseDown, _isMouseOver);
				dispatchEvent(evt);
			}
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if (!enabled) 
            {
                event.stopImmediatePropagation();
                return;
            }

			if(event.buttonDown && !getIsButtonDown()) return;
            
			_isMouseOver = false;
			
			currentState = getCurrentSkinState();
			
			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_ROLL_OUT))
			{
				var evt:ViburnumMouseEvent = new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_ROLL_OUT, false, false, 
					event.localX, event.localY, event.stageX, event.stageY, 
					event.ctrlKey, event.altKey, event.shiftKey, _isMouseDown, _isMouseOver);
				dispatchEvent(evt);
			}
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(!enabled) 
			{
				event.stopImmediatePropagation();
				return;
			}
			
			_isMouseDown = true;
			
			currentState = getCurrentSkinState();
			
			_mouseDownGlobalPoint = new Point(event.stageX, event.stageY);

			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			
			checkAutoRepeatTimerConditions();

			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_DOWN))
			{
				dispatchEvent(new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_DOWN));
			}
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if(!enabled)
			{
				event.stopImmediatePropagation();
				return;
			}
		}
		
		protected function get keyboardPressed():Boolean
		{
			return _isKeyboardPressed;
		}
		
		protected function set keyboardPressed(value:Boolean):void
		{
			if(value == _isKeyboardPressed) return;
			
			_isKeyboardPressed = value;
			
			currentState = getCurrentSkinState();
		}

		override protected function getCurrentSkinState():String//up over down disable
		{
			if(!enabled)
			{
				return StateName.DISABLED;
			}
			else if(_isMouseOver && getIsButtonDown())
			{
				return StateName.DOWN;
			}
			else if(_isMouseOver && !getIsButtonDown() || !_isMouseOver && getIsButtonDown())
			{
				return StateName.OVER;
			}
			else
			{
				return StateName.UP;
			}
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			
			if(!enabled) 
			{
				event.stopImmediatePropagation();
				return;
			}

			if(event.keyCode == Keyboard.SPACE)
			{
				keyboardPressed = true;
				
				event.updateAfterEvent();
			}
		}
		
		override protected function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode != Keyboard.SPACE) return;
			
			if(!enabled) 
			{
				event.stopImmediatePropagation();
				return;
			}

			// Mimic mouse click on the button.
			keyboardPressed = false;
			
			if(hasEventListener(MouseEvent.CLICK))
			{
				var mouseClickEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK, false);
				mouseClickEvent.localX = this.mouseX;
				mouseClickEvent.localY = this.mouseY;
				dispatchEvent(mouseClickEvent);
			}
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		private function getIsButtonDown():Boolean
		{
			return _isKeyboardPressed || _isMouseDown;
		}
		
		private function checkAutoRepeatTimerConditions():void
		{
			var needsTimer:Boolean = _autoRepeat && getIsButtonDown();
			var hasTimer:Boolean = _autoRepeatTimer != null && _autoRepeatTimer.running;
			if (needsTimer == hasTimer) return;

			if(needsTimer)
			{
				startAutoRepeatTimer();
			}
			else
			{
				stopAutoRepeatTimer();
			}
		}
		
		private function startAutoRepeatTimer():void
		{
			if(_autoRepeatTimer == null)
			{
				_autoRepeatTimer = new Timer(1);
				_autoRepeatTimer.delay = getStyle("repeatInterval") || 50;
				_autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeatTimerDelayHandler);
			}
			else
			{
				_autoRepeatTimer.reset();
			}
			
			_autoRepeatTimer.start();
		}

		private function stopAutoRepeatTimer():void
		{
			if(_autoRepeatTimer != null)
			{
				_autoRepeatTimer.stop();
			}
		}
		
		private function autoRepeatTimerDelayHandler(event:TimerEvent = null):void
		{
			if(this.hasEventListener(ViburnumMouseEvent.BUTTON_DOWN))
			{
				dispatchEvent(new ViburnumMouseEvent(ViburnumMouseEvent.BUTTON_DOWN));
			}
		}
	}
}