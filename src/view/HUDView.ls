package
{
    import UI.View;
    import UI.ViewCallback;
    import UI.Label;
    
    import Loom.Animation.Tween;
    import Loom.Animation.EaseType;
    import Loom.LML.LML;
    
    import cocos2d.CCNode;
    import cocos2d.CCPoint;
    import cocos2d.CCScaledLayer;
    import cocos2d.CCLayerColor;
    import cocos2d.ccColor4B;
    
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
            if (_time)
            {
                _time.setAnchorPoint(new CCPoint(0, 0.5));
                _time.text = "Survival Time: 0";
            }
            if (_bestTime)
            {
                _bestTime.setAnchorPoint(new CCPoint(0, 0.5));
                _bestTime.text = "Longest Run: 0";
            }
            if (_health)
            {
                _health.setAnchorPoint(new CCPoint(0, 0.5));
                _health.text = "Health: " + GameLevel.INITIAL_HEALTH_MS;
            }
            //if (_polarity)
            //{
            //    _polarity.setAnchorPoint(new CCPoint(0, 0.5));
            //    _polarity.text = "Polarity: 0";
            //}
        }
        
        public function onGameBegan()
        {
            _startPrompt.setVisible(false);
        }
        
        public function onTimeChanged(survivalTime:int, health:int, bestTime:int)
        {
            _time.text = "Survival Time: " + Math.round(survivalTime / 1000);
            _health.text = "Health: " + health;
            _bestTime.text = "Longest Run: " + Math.round(bestTime / 1000);
        }
        
        public function onPolarityChanged(polarity:int)
        {
            //_polarity.text = "Polarity: " + (polarity > 0 ? "+" : "") + polarity;
        }
        
        public function enter(parent:CCNode)
        {
            super.enter(parent);
            
            if (_startPrompt)
            {
                _startPrompt.setVisible(true);
            }
            
            parent.reorderChild(this, 10);
        }
        
        public function exit()
        {
            super.exit();
        }
    }
}