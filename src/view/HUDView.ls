package
{
	import loom.lml.LML;
	import loom2d.display.DisplayObjectContainer;
    import loom2d.Loom2D;
	import loom2d.ui.Label;
	import ui.View;
    
    public class HUDView extends View
    {
        [Bind]
        protected var _time:Label;
        [Bind]
        protected var _health:Label;
        //[Bind]
        //protected var _polarity:Label;
        [Bind]
        protected var _bestTime:Label;
        [Bind]
        protected var _startPrompt:Label;
        
        public function HUDView()
        {
            super();

            var doc = LML.bind("assets/hud.lml", this);
            doc.onLMLCreated = onLMLCreated;
            doc.apply();
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
            //if (_polarity)
            //{
            //    _polarity.pivotY = 0.5;
            //    _polarity.text = "Polarity: 0";
            //}
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
        
        public function onPolarityChanged(polarity:int)
        {
            //_polarity.text = "Polarity: " + (polarity > 0 ? "+" : "") + polarity;
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