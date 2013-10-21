package com.viburnum.skins
{
	import com.viburnum.interfaces.IStateClient;
	
	import flash.display.MovieClip;

	public class StateableMovieClipSkin extends MovieClip implements IStateClient
	{
		private var _currentState:String = null;
		
		public function StateableMovieClipSkin()
		{
			super();
		}

		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState != value)
			{
				_currentState = value;
				
				gotoAndPlay(value);
			}
		}
	}
}