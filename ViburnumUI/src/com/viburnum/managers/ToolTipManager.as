package com.viburnum.managers
{
    import com.viburnum.components.IApplication;
    import com.viburnum.components.IToolTip;
    import com.viburnum.components.IToolTipClient;
    import com.viburnum.components.ToolTip;
    import com.viburnum.events.ToolTipEvent;
    import com.viburnum.interfaces.IPluginEntity;
    
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

	//在合理的时间范围内ToolTipManager一般会使用一个共享的ToolTip来显示
    public class ToolTipManager implements IToolTipManager
    {
		public static const TOOLTIP_LAYER:String = "toolTipLayer";
		
		protected var myApplication:IApplication;
		protected var toolTipLayer:ToolTipLayer;
		
		private var _showDelayTimer:Timer;
		private var _hideDelayTimer:Timer;
		private var _scrubDelayTimer:Timer;

		private var _currentTarget:InteractiveObject;
		private var _currentTargetToolTipShowed:Boolean = false;

		private var _currentToolTip:IToolTip;
		private var _toolTipClass:Class = ToolTip;

		private var _enabled:Boolean = true;

		private var _showDelay:uint = 100; // milliseconds
		private var _scrubDelay:uint = 100; // milliseconds
		private var _hideDelay:uint = 3000; // milliseconds
		
		private var _registedToolTipClientsMap:Dictionary = new Dictionary(true);

        public function ToolTipManager()
        {
            super();
        }
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return myApplication;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			myApplication = value as IApplication;
		}
		
		public function onAttachToPluginEntity():void
		{
			if(!toolTipLayer) toolTipLayer = createToolTipLayer() as ToolTipLayer;

			toolTipLayer.application = myApplication;
			
			myApplication.addChildToLayerByLayerName(toolTipLayer, LayerChildrenNames.MIDDLE_LAYER_NAME);
		}
		
		protected function createToolTipLayer():Sprite
		{
			var s:Sprite = new ToolTipLayer();
			s.name = "ToolTipManager_ToolTipLayer";
			
			return s;
		}
		
		public function onDettachFromPluginEntity():void
		{
			toolTipLayer.application = null;
			
			myApplication.removeChildFromLayerByLayerName(toolTipLayer, LayerChildrenNames.MIDDLE_LAYER_NAME);
		}

        //IToolTipManager Interface=============================================
        public function get currentToolTip():IToolTip
        {
            return _currentToolTip;
        }
		
		public function get currentToolTipClient():InteractiveObject
		{
			return _currentTarget;
		}
        
        public function get enabled():Boolean
        {
            return _enabled;
        }
        
        public function set enabled(value:Boolean):void
        {
			_enabled = value;
        }
        
		public function get showDelay():uint
		{
			return _showDelay;
		}
		
		public function set showDelay(value:uint):void
		{
			_showDelay = value;
		}
		
        public function get hideDelay():uint
        {
            return _hideDelay;
        }
        
        public function set hideDelay(value:uint):void
        {
			_hideDelay = value;
        }
        
        public function get scrubDelay():uint
        {
            return _scrubDelay;
        }
        
        public function set scrubDelay(value:uint):void
        {
			_scrubDelay = value;
        }
        
        public function get toolTipClass():Class
        {
            return _toolTipClass;
        }
        
        public function set toolTipClass(value:Class):void
        {
			_toolTipClass = value;
        }

		public final function registToolTipClient(target:InteractiveObject):void
		{
			//null 2 undefined
			if(!target) return;
			
			if(!_registedToolTipClientsMap[target])
			{
				_registedToolTipClientsMap[target] = true;
				
				target.addEventListener(MouseEvent.ROLL_OVER, toolTipMouseRollOverHandler, false, 0, true);
				target.addEventListener(MouseEvent.ROLL_OUT, toolTipMouseRollOutHandler, false, 0, true);
			}
		}

		public final function unRegistToolTipClient(target:InteractiveObject):void
		{
			//null 2 undefined
			if(!target) return;

			if(_registedToolTipClientsMap[target])
			{
				delete _registedToolTipClientsMap[target];

				target.removeEventListener(MouseEvent.ROLL_OVER, toolTipMouseRollOverHandler);
				target.removeEventListener(MouseEvent.ROLL_OUT, toolTipMouseRollOutHandler);
			}
		}

		public function showTargetToolTip(target:InteractiveObject, immediately:Boolean = false):void
		{
			if(!enabled || target == _currentTarget) return;

			resetShowDelayTimer();
			resetHideDelayTimer();

			toolTipLayer.removeFrameWorkToolTip();

			_currentTarget = target;

			if(_currentTarget != null)
			{
				if(immediately)
				{
					showTimerDelayTimerCompleteHandler(null);
				}
				else
				{
					startShowDelayTimer();
				}
			}
		}

		public function destroyCurrentToolTip():void
		{
			if(!enabled) return;

			toolTipLayer.removeFrameWorkToolTip();
			
			_currentToolTip = null;
			_currentTarget = null;
			resetShowDelayTimer();
			resetHideDelayTimer();
		}

		public function showCustomToolTip(toolTip:IToolTip, postionX:Number, postionY:Number):void
		{
			if(!enabled || toolTip == null || toolTip == _currentToolTip) return;
			
			if(toolTipLayer != null)
			{
				toolTipLayer.addCustomToolTip(DisplayObject(toolTip), postionX, postionY);
			}
		}

		public function removeCustomToolTip(toolTip:IToolTip):void
		{
			if(!enabled || toolTip == null || toolTip == _currentToolTip) return;
			
			if(toolTipLayer != null)
			{
				toolTipLayer.removeCustomToolTip(DisplayObject(toolTip));
			}
		}
		
		public function removeAllCustomToolTip():void
		{
			if(!enabled) return;
			
			if(toolTipLayer != null)
			{
				toolTipLayer.removeAllCustomToolTip();
			}
		}
		
		//scrubDelay effect here
		private function toolTipMouseRollOverHandler(event:MouseEvent):void
		{
//			trace("toolTipMouseRollOverHandler");
			if(!enabled) return;
			
			_currentTarget = event.currentTarget as InteractiveObject;

			if(!getScrubDelayTimerRunning())
			{
				startScrubTimer();
				resetHideDelayTimer();
				startShowDelayTimer();
			}
		}
		
		private function toolTipMouseRollOutHandler(event:MouseEvent):void
		{
//			trace("toolTipMouseRollOutHandler");
			if(!enabled) return;

			_currentTarget = null;
			
			if(!getScrubDelayTimerRunning())
			{
				startScrubTimer();

				if(!getShowDelayTimerRunning() && !getHideDelayTimerRunning())
				{
					_currentToolTip = null;
				}

				resetShowDelayTimer();
				resetHideDelayTimer();

				toolTipLayer.removeFrameWorkToolTip();
			}
		}

		private function startScrubTimer():void
		{
			if(_scrubDelayTimer == null)
			{
				_scrubDelayTimer = new Timer(_scrubDelay, 1);
				_scrubDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, scrubDelayTimerCompleteHandler);
			}

			if(!_scrubDelayTimer.running)
			{
				_scrubDelayTimer.delay = _scrubDelay;
				_scrubDelayTimer.start();
			}
		}

		private function scrubDelayTimerCompleteHandler(event:TimerEvent):void
		{
			if(!_currentTargetToolTipShowed)
			{
				showTimerDelayTimerCompleteHandler(null);
			}
		}

		private function getScrubDelayTimerRunning():Boolean
		{
			return _scrubDelayTimer == null ? false : _scrubDelayTimer.running;
		}

		private function startShowDelayTimer():void
		{
			resetShowDelayTimer();

			if(_showDelayTimer == null)
			{
				_showDelayTimer = new Timer(_showDelay, 1);
				_showDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerDelayTimerCompleteHandler);
			}

			_showDelayTimer.delay = _showDelay;
			_showDelayTimer.start();
		}
		
		private function resetShowDelayTimer():void
		{
			if(_showDelayTimer != null && _showDelayTimer.running)
			{
				_showDelayTimer.reset();
			}
		}
		
		private function getShowDelayTimerRunning():Boolean
		{
			return _showDelayTimer != null ? _showDelayTimer.running : false;
		}
		
		private function showTimerDelayTimerCompleteHandler(event:TimerEvent):void
		{
			if(_currentTarget)
			{
				_currentToolTip = createToolTip(_currentTarget);
				
				if(_currentToolTip != null)
				{
					toolTipLayer.showFrameWorkToolTip(DisplayObject(_currentToolTip));
					
					startHideDelayTimer();
				}
				else
				{
					toolTipLayer.removeFrameWorkToolTip();
				}
			}
			else
			{
				toolTipLayer.removeFrameWorkToolTip();
			}
		}

		private function startHideDelayTimer():void
		{
			resetHideDelayTimer();
			
			if(_hideDelayTimer == null)
			{
				_hideDelayTimer = new Timer(_hideDelay, 1);
				_hideDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerDelayTimerCompleteHandler);
			}

			_hideDelayTimer.delay = _hideDelay;
			_hideDelayTimer.start();
		}
		
		private function resetHideDelayTimer():void
		{
			if(_hideDelayTimer != null && _hideDelayTimer.running)
			{
				_hideDelayTimer.reset();
			}
		}
		
		private function getHideDelayTimerRunning():Boolean
		{
			return _hideDelayTimer != null ? _hideDelayTimer.running : false;
		}

		private function hideTimerDelayTimerCompleteHandler(event:TimerEvent):void
		{
			if(_currentTarget != null)
			{
				if(_currentTarget.hasEventListener(ToolTipEvent.TOOL_TIP_DESTORY))
				{
					var toolTipEvent:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_DESTORY);
					_currentTarget.dispatchEvent(toolTipEvent);	
				}
				
				_currentTarget = null;
			}
			
			toolTipLayer.removeFrameWorkToolTip();
		}

		//--
		private function createToolTip(targetToolTipClient:InteractiveObject):IToolTip
		{
			var showTip:IToolTip = _currentToolTip;

			if(_currentTarget.hasEventListener(ToolTipEvent.TOOL_TIP_CREATE))
			{
				var toolTipEvent:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_CREATE);
				_currentTarget.dispatchEvent(toolTipEvent);
				
				if(toolTipEvent.toolTip != null)
				{
					showTip = toolTipEvent.toolTip;
				}
			}
			
			showTip ||= new toolTipClass();

			if(showTip != null)
			{
				if(targetToolTipClient is IToolTipClient)
				{
					showTip.toolTip = IToolTipClient(targetToolTipClient).toolTip;
				}
				else
				{
					showTip.toolTip = toolTipEvent.tips;
				}
			}

			return showTip;
		}
    }
}