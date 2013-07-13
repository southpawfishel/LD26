package
{
    import loom.animation.LoomTween;
	import loom.lml.LML;
    import loom.lml.LMLDocument;
    import loom2d.Loom2D;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.math.Point;
	import loom2d.ui.SimpleLabel;
	import ui.View;
    
    public class HUDView extends View
    {
        [Bind]
        protected var _time:SimpleLabel;
        [Bind]
        protected var _health:SimpleLabel;
        [Bind]
        protected var _bestTime:SimpleLabel;
        [Bind]
        protected var _startPrompt:SimpleLabel;
        
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
                _startPrompt.center();
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
            LoomTween.to(_startPrompt, 0.2, { "alpha" : 0 }).onComplete = function() { _startPrompt.visible = false; }
        }
        
        public function onTimeChanged(survivalTime:int, health:int, bestTime:int)
        {
            _time.text = "Survival Time: " + Math.round(survivalTime / 1000);
            _health.text = "Health: " + health;
            _bestTime.text = "Longest Run: " + Math.round(bestTime / 1000);
        }
        
        public function enter(parent:DisplayObjectContainer)
        {
            super.enter(parent);
            
            if (_startPrompt)
            {
                _startPrompt.visible = true;
                _startPrompt.alpha = 0;
                LoomTween.to(_startPrompt, 0.5, { "alpha" : 1 });
            }
            
            parent.setChildIndex(this, 10);
        }
        
        public function exit()
        {
            super.exit();
        }
    }
}