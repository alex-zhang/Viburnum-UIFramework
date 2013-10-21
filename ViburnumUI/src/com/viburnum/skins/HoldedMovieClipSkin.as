package com.viburnum.skins
{
	import flash.display.MovieClip;

	//[Style(name="holdedMovieClip", type="Class")]
	
	public class HoldedMovieClipSkin extends StateableProgrammaticSkin
	{
		protected var holdedMovieClip:MovieClip;
		
		public function HoldedMovieClipSkin()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			regenerateMoviClipHolder();
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "holderMovieClip")
			{
				regenerateMoviClipHolder();
			}
		}
		
		override protected function currentStateChanged(value:String):void
		{
			holdedMovieClipGotoState(value);
		}
		
		override protected function onDetachFromDisplayList():void
		{
			super.onDetachFromDisplayList();
			
			if(holdedMovieClip) holdedMovieClip.stop();
		}
		
		private function holdedMovieClipGotoState(state:String):void
		{
			if(holdedMovieClip != null)
			{
				holdedMovieClip.gotoAndPlay(state);
			}
		}

		private function regenerateMoviClipHolder():void
		{
			if(holdedMovieClip != null) return;
			
			var holdedMovieClipCls:Class = getStyle("holdedMovieClip");
			if(holdedMovieClipCls != null)
			{
				holdedMovieClip = new holdedMovieClipCls();
				
				if(holdedMovieClip != null)
				{
					holdedMovieClipGotoState(currentState);
					addChild(holdedMovieClip);
				}
			}
		}
	}
}