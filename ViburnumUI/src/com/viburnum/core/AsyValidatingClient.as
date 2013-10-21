package com.viburnum.core
{
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.interfaces.IRequestDriveAsynUpdater;
	import com.alex.utils.ObjectFactoryUtil;
	import com.alex.utils.ClassFactory;

	public class AsyValidatingClient implements IAsyValidatingClient
	{
		public var host:IAsyValidatingClient;
		
		private var _nestLevel:int = 0;
		
		private var _invalidatePropertiesFlag:Boolean = false;
		private var _invalidateSizeFlag:Boolean = false;
		private var _invalidateDisplayListFlag:Boolean = false;
		
		public function AsyValidatingClient(host:IAsyValidatingClient)
		{
			super();
			
			this.host = host;
		}
		
		//IAsyValidatingClient Interface
		public function get nestLevel():int
		{
			if(host) return host.nestLevel;
			
			return _nestLevel;
		}
		
		public function set nestLevel(value:int):void
		{
			if(host) host.nestLevel = value;
			
			_nestLevel = value;
		}
		
		public function invalidateProperties():void
		{
			if(!_invalidatePropertiesFlag)
			{
				_invalidatePropertiesFlag = true;
				requestDriveAsynUpdater.invalidateProperties(this);
			}
		}
		
		public function invalidateSize():void
		{
			if(!_invalidateSizeFlag)
			{
				_invalidateSizeFlag = true;
				requestDriveAsynUpdater.invalidateSize(this);
			}
		}
		
		public function invalidateDisplayList():void
		{
			if(!_invalidateDisplayListFlag)
			{
				_invalidateDisplayListFlag = true;
				requestDriveAsynUpdater.invalidateDisplayList(this);
			}
		}
		
		public function validateProperties():void
		{
			//this value set to be true before this validateProperties, 
			//that means you call invalidateProperties in the validateProperties progress.
			//all so the same rule with the "size" and "DisplayList" updating rule.
			_invalidatePropertiesFlag = false;
			if(host) host.validateProperties();
		}
		
		public function validateSize():void
		{
			_invalidateSizeFlag = false;
			if(host) host.validateSize();
		}
		
		public function validateDisplayList():void
		{
			_invalidateDisplayListFlag = false;
			if(host) host.validateDisplayList();
		}
		
		public function validateNow(skipNestLevel:Boolean = false):void
		{
			requestDriveAsynUpdater.validateNow(this, skipNestLevel);
		}
		
		public function toString():String
		{
			if(host) return host["toString"]();
			
			return "AsyValidatingClient";
		}
		
		//--
		
		private static var _requestDriveAsynUpdater:IRequestDriveAsynUpdater;
		
		private function get requestDriveAsynUpdater():IRequestDriveAsynUpdater
		{
			if(_requestDriveAsynUpdater) return _requestDriveAsynUpdater;

			_requestDriveAsynUpdater = ObjectFactoryUtil.getSingletonIntance(IRequestDriveAsynUpdater);
			
			if(!_requestDriveAsynUpdater)
			{
				_requestDriveAsynUpdater = ObjectFactoryUtil.registSingletonInstance(IRequestDriveAsynUpdater, 
					new ClassFactory(RequestDriveAsynUpdater, {"setStage":[host["stage"]]}).newInstance());
			}
			
			return _requestDriveAsynUpdater;
		}
	}
}