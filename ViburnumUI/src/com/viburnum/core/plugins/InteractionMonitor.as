package com.viburnum.core.plugins
{
	import com.viburnum.core.SystemStage;
	import com.viburnum.events.IdleEvent;
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.viburnum.interfaces.IInteractionMonitor;

	/**
	 * 当用户没有任何操作的时间超过idleThreshold时间后便会以idleInterval间隔触发该事件.
	 */	
	[Event(name="idle", type="com.viburnum.events.IdleEvent")]
	
	/**
	 * InteractionMonitor类实现对用户没有进行任何的鼠标和键盘活动的监测.
	 * 
	 * <p>当任何的鼠标或键盘事件都会重置监控状态标记，当Time以idleInterval的频率去检测
	 * passedIdleTime是否大于idleInterval设置的时间，如果超过则会触发idel事件。</p>
	 * 
	 * <p>由于侦听所有鼠标和键盘的活动很消耗资源的，所以该功能默认是关闭的，在需要使用时打开。</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	
	public class InteractionMonitor extends EventDispatcher implements IInteractionMonitor
	{
		private static const IDLE_THRESHOLD:uint = 5000;
		private static const IDLE_INTERVAL:uint = 500;

		protected var mySystemStage:SystemStage;
		protected var myStage:Stage;
		
		private var _idleThreshold:uint = IDLE_THRESHOLD;
		private var _idleInterval:uint = IDLE_INTERVAL;
		
		private var _isRunning:Boolean = false;

		private var _idleCounter:int = 0;
		private var _idleTimer:Timer;
		
		private var _stageIsActive:Boolean = true;

		public function InteractionMonitor()
		{
			super();
		}
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return mySystemStage;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			mySystemStage = value as SystemStage;
		}
		
		public function onAttachToPluginEntity():void
		{
			myStage = mySystemStage.stage;
		}
		
		public function onDettachFromPluginEntity():void
		{
			close();
			
			myStage = null;
		}
		
		//IInteractionMonitor Interface
		/**
		 * 获取idle判断时间，毫秒单位.
		 * 
		 * @return idleThreshold
		 * 
		 */		
		public function get idleThreshold():uint
		{
			return _idleThreshold;
		}
		
		/**
		 * 设置idle判断时间，毫秒单位，需要重启.
		 * 
		 * @return idleThreshold
		 * 
		 */	
		public function set idleThreshold(value:uint):void
		{
			_idleThreshold = value;
		}
		
		/**
		 * 获取idle监测频率，毫秒单位.
		 */		
		public function get idleInterval():uint
		{
			return _idleInterval;
		}
		
		/**
		 * 设置idle监测频率，毫秒单位, 需要重启.
		 */
		public function set idleInterval(value:uint):void
		{
			_idleInterval = value;
		}
		
		/**
		 * 获取用户没有活动的时间.
		 *  
		 * @return  passedIdleTime
		 * 
		 */		
		public function get passedIdleTime():uint
		{
			return _isRunning ? _idleInterval * _idleCounter : 0;
		}
		
		/**
		 * 返回当前是否在侦听.
		 *  
		 * @default false 
		 * 
		 */		
		public function get isListening():Boolean
		{
			return _isRunning;
		}
		
		public function get stageIsActive():Boolean
		{
			return _stageIsActive;
		}
		
		/**
		 * 打开侦听. 
		 */		
		public function open():void
		{
			if(_isRunning) return;
			
			_isRunning = true;
			
			mySystemStage.addEventListener(Event.ACTIVATE, stageActiveHandler, false, int.MAX_VALUE, true);
			mySystemStage.addEventListener(Event.DEACTIVATE, stageDeActiveHandler, false, int.MAX_VALUE, true);
			
			mySystemStage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			mySystemStage.addEventListener(MouseEvent.MOUSE_UP, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			mySystemStage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			mySystemStage.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			
			mySystemStage.addEventListener(KeyboardEvent.KEY_DOWN, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			mySystemStage.addEventListener(KeyboardEvent.KEY_UP, stageMouse2KeyActiveHandler, false, int.MAX_VALUE, true);
			
			if(_idleTimer == null)
			{
				_idleTimer = new Timer(_idleInterval);
				_idleTimer.addEventListener(TimerEvent.TIMER, idleTimerHandler);
			}
			
			_idleTimer.start();
		}
		
		/**
		 * 关闭侦听.
		 */		
		public function close():void
		{
			if(!_isRunning) return;
			
			_isRunning = false;
			
			_idleCounter = 0;
			
			mySystemStage.removeEventListener(Event.ACTIVATE, stageActiveHandler);
			mySystemStage.removeEventListener(Event.DEACTIVATE, stageDeActiveHandler);
			
			mySystemStage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouse2KeyActiveHandler);
			mySystemStage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouse2KeyActiveHandler);
			mySystemStage.removeEventListener(MouseEvent.MOUSE_UP, stageMouse2KeyActiveHandler);
			mySystemStage.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouse2KeyActiveHandler);
			
			mySystemStage.removeEventListener(KeyboardEvent.KEY_DOWN, stageMouse2KeyActiveHandler);
			mySystemStage.removeEventListener(KeyboardEvent.KEY_UP, stageMouse2KeyActiveHandler);
			
			if(_idleTimer != null)
			{
				_idleTimer.removeEventListener(TimerEvent.TIMER, idleTimerHandler);
				_idleTimer = null;
			}
		}
		
		/**
		 * 重新开启侦听.
		 */		
		public function restart():void
		{
			close();
			open();
		}
		
		//event handler
		private function idleTimerHandler(event:TimerEvent):void
		{
			if(!_stageIsActive) return;
			
			_idleCounter++;
			
			if(passedIdleTime > _idleThreshold)
			{
				if(hasEventListener(IdleEvent.IDLE))
				{
					dispatchEvent(new IdleEvent(IdleEvent.IDLE));
				}
			}
		}
		
		private function stageActiveHandler(event:Event):void
		{
			_stageIsActive = true;
			
			if(hasEventListener(IdleEvent.ACTIVED))
			{
				dispatchEvent(new IdleEvent(IdleEvent.ACTIVED));
			}
		}
		
		private function stageDeActiveHandler(event:Event):void
		{
			_stageIsActive = false;
			
			if(hasEventListener(IdleEvent.DEACTIVED))
			{
				dispatchEvent(new IdleEvent(IdleEvent.DEACTIVED));
			}
		}
		
		private function stageMouse2KeyActiveHandler(event:Event):void
		{
			_idleCounter = 0;
		}
	}
}