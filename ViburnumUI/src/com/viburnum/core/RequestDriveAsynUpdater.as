package com.viburnum.core
{
    import com.viburnum.interfaces.IAsyValidatingClient;
    import com.viburnum.interfaces.IRequestDriveAsynUpdater;
    
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.Event;
    
	/**
	 * RequestDriveAsynUpdater是一个异步更新器.
	 * 
	 * <p>RequestDriveAsynUpdater和Flex中的LayoutManager的功能一样，对所有请求的异步更新操作，.
	 * 都按照其某种规则来同步更新。</p>
	 * <pre>
	 * 	<ul>
	 * 		<li> 1.所有的请求在异步更新器中都按阶段的执行:propertiesUpdate阶段->sizeUpdate阶段->displayListUpdate阶段</li>
	 * 		<li> 2.每个阶段并须全部更新完成后才能进入下个阶段。</li>
	 *  	<li> 3.propertiesUpdate阶段 内部执行的顺序为从nestLevel(小)->nestLevel(大)执行(显示列表中理解为从外到里)</li>
	 *  	<li> 4.sizeUpdate阶段阶段 内部执行的顺序为从nestLevel(大)->nestLevel(小)执行(显示列表中理解为从里到外)</li>
	 * 		<li> 5.displayListUpdate阶段阶段 内部执行的顺序为从nestLevel(小)->nestLevel(大)执行(显示列表中理解为从外到里)</li>
	 * 		<li> 5.validateNow则任然是按照上面的顺序去更新</li>
	 * 	</ul>	
	 * </pre>
	 * 
	 * <p>异步更新器的驱动是由Stage Event.EXIT_FRAME和Stage的Event.RENDER来驱动，以保证执行效率和及时性</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */	
    public class RequestDriveAsynUpdater implements IRequestDriveAsynUpdater
    {
		protected var myStage:Stage;
		
        private var _invalidatePropertiesFlag:Boolean = false;
        private var _invalidateSizeFlag:Boolean = false;
        private var _invalidateDisplayListFlag:Boolean = false;

        private const _invalidatePropertiesQueue:AsyValidatingClientPriorityQueue = new AsyValidatingClientPriorityQueue();
        private const _invalidateSizeQueue:AsyValidatingClientPriorityQueue = new AsyValidatingClientPriorityQueue();
        private const _invalidateDisplayListQueue:AsyValidatingClientPriorityQueue = new AsyValidatingClientPriorityQueue();
		
		private var _isListenProgressEngine:Boolean = false;

		/**
		 * 构造函数.
		 *  
		 * @param rootDisplayObject
		 * 
		 */		
        public function RequestDriveAsynUpdater()
        {
            super();
        }
		
		//IRequestDriveAsynUpdater Interface====================================
		
		public function setStage(stage:Stage):void
		{
			myStage = stage;
		}
        
		/**
		 * 提交属性异步更新请求.
		 *  
		 * @param target
		 * 
		 */	
        public function invalidateProperties(target:IAsyValidatingClient):void
        {
			_invalidatePropertiesQueue.addChild(target);
//			trace(target, "=>invalidateProperties", target.nestLevel);
			if(!_invalidatePropertiesFlag)
            {
				_invalidatePropertiesFlag = true;

				attachProgressEngine();
            }
        }
        
		/**
		 * 提交尺寸异步更新请求
		 * 
		 * @param target
		 * 
		 */	
        public function invalidateSize(target:IAsyValidatingClient):void
        {
			_invalidateSizeQueue.addChild(target);
//			trace(target, "=>invalidateSize", target.nestLevel);
			if(!_invalidateSizeFlag)
            {
				_invalidateSizeFlag = true;
				
				attachProgressEngine();
            }
        }
        
		/**
		 * 提交显示列表异步更新请求
		 * 
		 * @param target
		 * 
		 */	
        public function invalidateDisplayList(target:IAsyValidatingClient):void
        {
			_invalidateDisplayListQueue.addChild(target);
//			trace(target, "=>invalidateDisplayList", target.nestLevel);
			if(!_invalidateDisplayListFlag)
            {
				_invalidateDisplayListFlag = true;

				attachProgressEngine();
            }
        }

		/**
		 * 同步更新所有.
		 *  
		 * @param target
		 * @param skipNestLevel
		 * 
		 */	
        public function validateNow(target:IAsyValidatingClient = null, skipDisplayList:Boolean = false):void
        {
			if(target == null)//framework validateNow
			{
				while(isInvalid())
				{
					if(_invalidatePropertiesFlag) validateProperties();
					if(_invalidateSizeFlag) validateSize();
					if(_invalidateDisplayListFlag) validateDisplayList();
				}
			}
			else
			{
				if(skipDisplayList)
				{
					target.validateProperties();
					target.validateSize();
					target.validateDisplayList();
				}
				else
				{
					var c:IAsyValidatingClient = null;
					//_invalidatePropertiesQueue
					c = target;
					while(c != null)
					{
						c = _invalidatePropertiesQueue.removeSmallestByRootChild(target);
						if(c != null)
						{
							c.validateProperties();
						}
					}
					//_invalidateSizeQueue
					c = target;
					while(c != null)
					{
						c = _invalidateSizeQueue.removeLargestByRootChild(target);
						if(c != null)
						{
							c.validateSize();
						}
					}
					//_invalidateDisplayListQueue
					c = target;
					while(c != null)
					{
						c = _invalidateSizeQueue.removeSmallestByRootChild(target);
						if(c != null)
						{
							c.validateSize();
						}
					}
				}
			}
        }

        public function isInvalid():Boolean
        {
            return _invalidatePropertiesFlag || 
				_invalidateSizeFlag || 
				_invalidateDisplayListFlag;
        }
        
		/**
		 * 返回 更新器是否处于失效状态，需要在更新.
		 */	
        private function validateProperties():void
        {
			while(!_invalidatePropertiesQueue.isEmpty())
            {
				var target:IAsyValidatingClient = _invalidatePropertiesQueue.removeSmallest();
				if(target != null)
				{
//					trace(target, "=>validateProperties", target.nestLevel);
					target.validateProperties();
				}
            }

			_invalidatePropertiesFlag = false;
        }

        private function validateSize():void
        {
			while(!_invalidateSizeQueue.isEmpty())
            {
				var target:IAsyValidatingClient = _invalidateSizeQueue.removeLargest();
				if(target != null)
				{
//					trace(target, "=>validateSize", target.nestLevel);
					target.validateSize();
				}
            }
			
			_invalidateSizeFlag = false;
        }

        private function validateDisplayList():void
        {
			while(!_invalidateDisplayListQueue.isEmpty())
            {
				var target:IAsyValidatingClient = _invalidateDisplayListQueue.removeSmallest();
				if(target != null)
				{
//					trace(target, "=>validateDisplayList", target.nestLevel);
					target.validateDisplayList();
				}
            }

			_invalidateDisplayListFlag = false;
        }

        private function attachProgressEngine():void
        {
			if(!_isListenProgressEngine)
			{
//				TimeUtil.recordCurrentRunTime("RequestDriveAsynUpdater");
				_isListenProgressEngine = true;
				
				myStage.addEventListener(Event.ENTER_FRAME, engineUpdateHandler, false, 0, true);
				myStage.addEventListener(Event.RENDER, engineUpdateHandler, false, 0, true);
				
				myStage.invalidate();
			}
        }

        private function dettachProgressEngine():void
        {
			if(_isListenProgressEngine)
			{
//				TimeUtil.recordCurrentRunTime("RequestDriveAsynUpdater");
//				trace("RequestDriveAsynUpdater 执行时间:", TimeUtil.getRecordedTotalRunTime("RequestDriveAsynUpdater"), "=====================================");
//				TimeUtil.clearRecordedRunTime("RequestDriveAsynUpdater");
				
				_isListenProgressEngine = false;
				
				myStage.removeEventListener(Event.ENTER_FRAME, engineUpdateHandler);
				myStage.removeEventListener(Event.RENDER, engineUpdateHandler);
			}
        }
        
        private function engineUpdateHandler(event:Event):void
        {
//			TimeUtil.recordCurrentRunTime("RequestDriveAsynUpdater");
			if(_invalidatePropertiesFlag) validateProperties();
			if(_invalidateSizeFlag) validateSize();
			if(_invalidateDisplayListFlag) validateDisplayList();

//			trace("engineUpdateHandler");
			if(isInvalid())
			{
//				trace("attachProgressEngine");
				attachProgressEngine();
			}
			else
			{
//				trace("dettachProgressEngine");
				dettachProgressEngine();
			}
//			TimeUtil.recordCurrentRunTime("RequestDriveAsynUpdater");
//			trace("==============", TimeUtil.getRecordedTotalRunTime("RequestDriveAsynUpdater"));
        }
    }
}

    import com.viburnum.interfaces.IAsyValidatingClient;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    internal final class AsyValidatingClientPriorityQueue
    {
		//_arrayOfArrays在priority索引空间会保留空间，不会将某个已经创建的priority的空间删除
        private var _arrayOfArrays:Array = [];//IAsyValidatingClient
        
		//当前_arrayOfArrays的最大索引和最小索引值
        private var _minPriority:int = 0;
        private var _maxPriority:int = -1;

        public function AsyValidatingClientPriorityQueue()
        {
            super();
        }

        public function addChild(client:IAsyValidatingClient):void
        {
			var priority:int = client.nestLevel;

            if(!_arrayOfArrays[priority]) _arrayOfArrays[priority] = [];

            _arrayOfArrays[priority].push(client);

            if(_maxPriority < _minPriority)//表示当前为空
            {
                _minPriority = _maxPriority = priority;//重新建立最大最小索引
            }
            else
            {
                if(priority < _minPriority) _minPriority = priority;
                if(priority > _maxPriority) _maxPriority = priority;
            }
        }
		
		public function removeLargest():IAsyValidatingClient
        {
			while(_maxPriority >= _minPriority)
			{
				if(_arrayOfArrays[_maxPriority] && _arrayOfArrays[_maxPriority].length > 0)
				{
					var c:IAsyValidatingClient = _arrayOfArrays[_maxPriority].shift();
					
					if(_arrayOfArrays[_maxPriority].length == 0)
					{
						_maxPriority--;
					}
//					trace("removeLargest", c);
					return c;
				}
				else
				{
					_maxPriority--;
				}
			}
//			trace("removeLargest", "error null");
			return null;
        }
        
        public function removeSmallest():IAsyValidatingClient
        {
			while(_minPriority <= _maxPriority)
			{
				if(_arrayOfArrays[_minPriority] && _arrayOfArrays[_minPriority].length > 0)
				{
					var c:IAsyValidatingClient = _arrayOfArrays[_minPriority].shift();
					
					if(_arrayOfArrays[_minPriority].length == 0)
					{
						_minPriority++;
					}
					
//					trace("removeSmallest", c);
					return c;
				}
				else
				{
					_minPriority++;
				}
			}
			
//			trace("removeSmallest", "error null", _minPriority, _maxPriority);
			return null;
        }
		
		//从rootChild的priority-_maxPriority范围所搜, 每次都需要经历该范围，因为该过程中仍然有IInvalidatingClient加进来，所以要持续处理
		public function removeSmallestByRootChild(rootChild:IAsyValidatingClient):IAsyValidatingClient
		{
			var priority:int = rootChild.nestLevel;

			//rootChild被移除后，此时priority可能小于_minPriority
			if(priority < _minPriority) priority = _minPriority;
			
			var rootChildIsContainer:Boolean = rootChild is DisplayObjectContainer;

			//重当前rootChild的向大的priority搜索
			while(priority <= _maxPriority)
			{
				if(_arrayOfArrays[priority] && _arrayOfArrays[priority].length > 0)
				{
					var n:uint = _arrayOfArrays[priority].length;
					for(var i:uint = 0; i < n; i++)
					{
						var c:IAsyValidatingClient = _arrayOfArrays[priority][i];
						
						if((rootChildIsContainer && DisplayObjectContainer(rootChild).contains(c as DisplayObject)) ||
							(!rootChildIsContainer && rootChild === c))
						{
							_arrayOfArrays[priority].splice(i, 1);
							
							//同步最小_minPriority
							if(priority == _minPriority && _arrayOfArrays[_minPriority].length == 0)
							{
								_minPriority++;
							}
							
							//同步最大_maxPriority
							if(priority == _maxPriority && _arrayOfArrays[_maxPriority].length == 0)
							{
								_maxPriority--;
							}

							return c;
						}
					}
				}
				
				//一个循环或当前priority为空,下来仍然没找到
				if(rootChildIsContainer)
				{
					//增加priority,以便在下个迭代中寻找
					priority++;
				}
				else
				{
					//当前非DisplayObjectContainer,且没有找到,结束寻找
					return null;
				}
			}

			return null;
		}
		
		//从rootChild的_maxPriority-rootChild.priority范围所搜, 每次都需要经历该范围，因为该过程中仍然有IInvalidatingClient加进来，所以要持续处理
		public function removeLargestByRootChild(rootChild:IAsyValidatingClient):IAsyValidatingClient
		{
			var priority:int = _maxPriority;
			var rootChildPriority:int = rootChild.nestLevel;
			var rootChildIsContainer:Boolean = rootChild is DisplayObjectContainer;
			
			while(priority >= rootChildPriority)
			{
				if(_arrayOfArrays[priority] && _arrayOfArrays[priority].length > 0)
				{
					var n:uint = _arrayOfArrays[priority].length;
					for(var i:uint = 0; i < n; i++)
					{
						var c:IAsyValidatingClient = _arrayOfArrays[priority][i];
						
						if((rootChildIsContainer && DisplayObjectContainer(rootChild).contains(c as DisplayObject)) ||
							(!rootChildIsContainer && rootChild === c))
						{
							_arrayOfArrays[priority].splice(i, 1);
							
							//同步最小_minPriority
							if(priority == _minPriority && _arrayOfArrays[_minPriority].length == 0)
							{
								_minPriority++;
							}
							
							//同步最大_maxPriority
							if(priority == _maxPriority && _arrayOfArrays[_maxPriority].length == 0)
							{
								_maxPriority--;
							}
							
							return c;
						}
					}
				}
				
				//一个循环或当前priority为空,下来仍然没找到
				if(rootChildIsContainer)
				{
					//增加priority,以便在下个迭代中寻找
					priority--;
				}
				else
				{
					//当前非DisplayObjectContainer,且没有找到,结束寻找
					return null;
				}
			}
			
			return null;
		}
		
        public function isEmpty():Boolean
        {
            return _minPriority > _maxPriority;
        }
    }