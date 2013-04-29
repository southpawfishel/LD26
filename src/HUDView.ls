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
    import cocos2d.CCUserDefault;
    import cocos2d.CCLayerColor;
    import cocos2d.ccColor4B;
    
    import Loom.GameFramework.LoomGroup;
    
    public class HUDView extends View
    {
        [Bind]
        protected var _time:Label;
        [Bind]
        protected var _health:Label;
        [Bind]
        protected var _polarity:Label;
        [Bind]
        protected var _bestTime:Label;
        [Bind]
        protected var _startPrompt:Label;
        
        public var onPause:ViewCallback = new ViewCallback();
        public var onReset:ViewCallback = new ViewCallback();
        
        protected var _timeValue:int = 0;
        protected var _bestTimeValue:int = 0;
        
        protected var _fadeToBlack:CCLayerColor = null;
        
        public function set opacity(value:int)
        {
            if (_fadeToBlack)
            {
                _fadeToBlack.setOpacity(value);
            }
        }
        
        public function get opacity():int
        {
            if (_fadeToBlack)
            {
                return _fadeToBlack.getOpacity();
            }
        }
        
        public function HUDView()
        {
            super();
            
            _bestTimeValue = CCUserDefault.sharedUserDefault().getIntegerForKey("bestTime", 0);

            var doc = LML.bind("assets/hud.lml", this);
            doc.onLMLCreated = onLMLCreated;
            doc.apply();
            
            onGameReset();
        }

        protected function onLMLCreated()
        {
            if (_time)
            {
                _time.setAnchorPoint(new CCPoint(0, 0.5));
                _time.text = "Survival Time: " + _timeValue;
            }
            if (_bestTime)
            {
                _bestTime.setAnchorPoint(new CCPoint(0, 0.5));
                _bestTime.text = "Longest Run: " + _bestTimeValue;
            }
            if (_health)
            {
                _health.setAnchorPoint(new CCPoint(0, 0.5));
                _health.text = "Health: " + GameLevel.INITIAL_HEALTH_MS;
            }
            if (_polarity)
            {
                _polarity.setAnchorPoint(new CCPoint(0, 0.5));
                _polarity.text = "Polarity: 0";
            }
        }
        
        public function onGameStart()
        {
            _timeValue = 0;
            _time.text = "Survival Time: " + _timeValue;
            _startPrompt.setVisible(false);
        }
        
        public function onGameReset()
        {
            _timeValue = 0;
            _time.text = "Survival Time: " + _timeValue;
            _startPrompt.setVisible(true);
        }
        
        public function onTimeChanged(milliseconds:int)
        {
            _timeValue  = Math.round(milliseconds / 1000);
            _time.text = "Survival Time: " + _timeValue;
            
            if (_timeValue > _bestTimeValue)
            {
                _bestTimeValue = _timeValue;
                _bestTime.text = "High: " + _bestTimeValue;
                CCUserDefault.sharedUserDefault().setIntegerForKey("bestTime", _bestTimeValue);
            }
        }
        
        public function onHealthChanged(milliseconds:int)
        {
            _health.text = "Health: " + milliseconds;
        }
        
        public function onPolarityChanged(polarity:int)
        {
            _polarity.text = "Polarity: " + (polarity > 0 ? "+" : "") + polarity;
        }
        
        public function onGameOver()
        {
            var black:ccColor4B = new ccColor4B();
            black.r = 0; black.g = 0; black.b = 0; black.a = 255;
            _fadeToBlack = CCLayerColor.create(black, 5000, 5000);
            _fadeToBlack.setOpacity(0);
            addChild(_fadeToBlack);
            
            Tween.to(this, 0.5, { "opacity" : 255 }).onComplete = function()
            {
                Tween.to(this, 0.5, { "opacity" : 0 }).onComplete = function()
                {
                    removeChild(_fadeToBlack, true);
                    _fadeToBlack = null;
                }
                onReset();
            }
        }
        
        public function enter(parent:CCNode)
        {
            super.enter(parent);
            parent.reorderChild(this, 10);
        }
        
        public function exit()
        {
            super.exit();
        }
    }
}