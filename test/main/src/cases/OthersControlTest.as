package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.HGroup;
	import com.viburnum.components.HRule;
	import com.viburnum.components.Label;
	import com.viburnum.components.SWFLoader;
	import com.viburnum.components.SimpleProgressBar;
	import com.viburnum.components.VGroup;
	import com.viburnum.components.VRule;
	import com.viburnum.layouts.FlowLayout;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class OthersControlTest extends ComponentTestBase
	{
		public function OthersControlTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			componentContainer.layout = new FlowLayout();
			
			var hrule:HRule = new HRule();
			componentContainer.addChild(hrule);
			
			//--
			
			var vrule:VRule = new VRule();
			componentContainer.addChild(vrule);
			
			//----
			
			var timer:Timer = new Timer(1, 100);
			timer.addEventListener(TimerEvent.TIMER, function timerHandler():void
			{
				s.value = timer.currentCount / timer.repeatCount * 100;
			});
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function timerCompleteHandler():void
			{
				timer.reset();
				timer.start();
			});
			
			timer.start();
			var s:SimpleProgressBar = new SimpleProgressBar();
			s.value = 20;

			componentContainer.addChild(s);
			
			var simpleProgressBarContainerAddedToStage:Boolean = true;
			s.addEventListener(Event.ADDED_TO_STAGE, 
				function():void
				{
					if(!simpleProgressBarContainerAddedToStage)
					{
						simpleProgressBarContainerAddedToStage = false;
						timer.start();
					}
				});

			s.addEventListener(Event.REMOVED_FROM_STAGE, 
				function():void 
				{
					if(simpleProgressBarContainerAddedToStage)
					{
						simpleProgressBarContainerAddedToStage = true;
						timer.stop();
					}
				});
			//--
			
			var swfloader:SWFLoader = new SWFLoader();
			swfloader.scaleContent = true;
			swfloader.source = "asstes/card1.png";
			componentContainer.addChild(swfloader);
		}
	}
}