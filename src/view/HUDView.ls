package
{
	import loom.lml.LML;
    import loom2d.Loom2D;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.math.Point;
	import loom2d.text.BitmapFont;
	import loom2d.ui.Label;
	import ui.View;
    
    public class HUDView extends View
    {
        //[Bind]
        protected var _time:Label;
        //[Bind]
        protected var _health:Label;
        //[Bind]
        protected var _bestTime:Label;
        //[Bind]
        protected var _startPrompt:Label;
        
        public function HUDView()
        {
            super();

/*            var doc = LML.bind("assets/hud.lml", this);
            doc.onLMLCreated = onLMLCreated;
            doc.apply();*/
			createLabels();
        }

		protected function createLabels()
		{
			_time = new Label("assets/Curse-hd.fnt", new Point(200, 100));
			_time.scale = 0.4;
			_time.x = 10;
			_time.y = 0;
			addChild(_time);
			_health = new Label("assets/Curse-hd.fnt", new Point(200, 100));
			_health.scale = 0.4;
			_health.x = 10;
			_health.y = 20;
			addChild(_health);
			_bestTime = new Label("assets/Curse-hd.fnt", new Point(200, 100));
			_bestTime.scale = 0.4;
			_bestTime.x = 10;
			_bestTime.y = 40;
			addChild(_bestTime);
			_startPrompt = new Label("assets/Curse-hd.fnt", new Point(400, 50));
			_startPrompt.text = "Touch Anywhere to Start";
			addChild(_startPrompt);
			
			onLMLCreated();
		}

        protected function onLMLCreated()
        {
            if (_startPrompt)
            {
                _startPrompt.x = Loom2D.stage.stageWidth / 2;
                _startPrompt.y = Loom2D.stage.stageHeight / 2;
                _startPrompt.pivotX = _startPrompt.width / 2;
                _startPrompt.pivotY = _startPrompt.height / 2;
            }
            if (_time)
            {
                _time.pivotY = _time.height / 2;
                _time.text = "Survival Time: 0";
            }
            if (_bestTime)
            {
                _bestTime.pivotY = _bestTime.height / 2;
                _bestTime.text = "Longest Run: 0";
            }
            if (_health)
            {
                _health.pivotY = _health.height / 2;
                _health.text = "Health: " + GameLevel.INITIAL_HEALTH_MS;
            }
        }
        
        public function onGameBegan()
        {
            _startPrompt.visible = false;
        }
        
        public function onTimeChanged(survivalTime:int, health:int, bestTime:int)
        {
            _time.text = "Survival Time: " + Math.round(survivalTime / 1000);
            //_health.text = "Health: " + health;
            _bestTime.text = "Longest Run: " + Math.round(bestTime / 1000);
        }
        
        public function enter(parent:DisplayObjectContainer)
        {
            super.enter(parent);
            
            if (_startPrompt)
            {
                _startPrompt.visible = true;
            }
            
            parent.setChildIndex(this, 10);
        }
        
        public function exit()
        {
            super.exit();
        }
    }
}