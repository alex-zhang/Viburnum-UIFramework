package com.viburnum.skins
{
	import com.viburnum.interfaces.IStateClient;

	public class StateableProgrammaticSkin extends ProgrammaticSkin implements IStateClient
	{
		private var _currentState:String = null;
		private var _currentStateChangedFlag:Boolean = false;
		
		public function StateableProgrammaticSkin()
		{
			super();
		}
		
		//IStateClient Interface==================================
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState != value)
			{
				_currentState = value;

				_currentStateChangedFlag = true;

				invalidateProperties();
				invalidateDisplayList();
			}
		}

		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_currentStateChangedFlag)
			{
				_currentStateChangedFlag = false;
				
				currentStateChanged(_currentState);
			}
		}

		protected function currentStateChanged(value:String):void
		{
		}
	}
}