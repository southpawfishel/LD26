package
{
    import Loom.GameFramework.LoomGameObject;
    import Loom.GameFramework.LoomGroup;
    import Loom.GameFramework.ITicked;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    import Loom.Platform.Timer;
    
    import CocosDenshion.SimpleAudioEngine;
    import cocos2d.ccColor4B;
    import cocos2d.CCLayerColor;
    import cocos2d.CCScaledLayer;
    import cocos2d.CCSpriteBatchNode;
    import cocos2d.CCPoint;
    import cocos2d.CCSize;
    import cocos2d.CCArray;
    import cocos2d.CCDictionary;
    import cocos2d.CCUserDefault;
    
    import System.Platform.Platform;
    
    public delegate GameBeganCallback():void;
    public delegate TimeChangedCallback(survivalTime:int, health:int, bestTime:int):void;
    public delegate GameOverCallback(survivalTime:int, bestTime:int):void;
    
    public class GameLevel extends LoomGroup implements ITicked
    {
        [Inject]
        private var _rootLayer:CCScaledLayer;
        [Inject]
        private var _timeManager:TimeManager;
        
        private var _bg:CCLayerColor;
        
        private var _playerOrb:LoomGameObject = null;
        private var _orbs:Vector.<LoomGameObject> = new Vector.<LoomGameObject>();
        
        private var _spawnTimer:Timer = new Timer(500);
        
        private var _gameRunning:Boolean = false;
        private var _gameStartTime:int = 0;
        
        public static var INITIAL_HEALTH_MS:int = 30000;
        private var _timeUntilDeath:int = INITIAL_HEALTH_MS;
        private var _playerGettingHurt:Boolean = false;
        private var _playerHurtPreviousTime:int = 0;
        
        protected var _survivalTime:int = 0;
        protected var _bestTime:int = 0;
        
        public var onGameBegan:GameBeganCallback = new GameBeganCallback();
        public var onPolarityChanged:PolarityChangedCallback = new PolarityChangedCallback();
        public var onTimeChanged:TimeChangedCallback = new TimeChangedCallback();
        public var onGameOver:GameOverCallback = new GameOverCallback();
    
        public function GameLevel()
        {
        }
    
        override public function initialize(objectName:String=null)
        {
            super.initialize(objectName);
            
            _timeManager.addTickedObject(this);
            
            _rootLayer.onTouchBegan += onTouchBegan;
            
            var bgColor:ccColor4B = new ccColor4B();
            bgColor.r = 100;
            bgColor.g = 100;
            bgColor.b = 100;
            bgColor.a = 255;
            _bg = CCLayerColor.create(bgColor, _rootLayer.designWidth, _rootLayer.designHeight);
            _rootLayer.addChild(_bg);
            
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.GOOD_SFX);
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.BAD_SFX);
            
            _bestTime = CCUserDefault.sharedUserDefault().getIntegerForKey("bestTime", 0);
            onTimeChanged(_survivalTime, _timeUntilDeath, _bestTime);
            
            _spawnTimer.onComplete = spawnRandomOrb;
        }
        
        override public function destroy()
        {
            _rootLayer.removeChild(_bg, true);
            
            _rootLayer.onTouchBegan -= onTouchBegan;
            
            _timeManager.removeTickedObject(this);
            
            if (_playerOrb)
            {
                _playerOrb.destroy();
            }
            
            for each (var orb in _orbs)
            {
                orb.destroy();
            }
        
            super.destroy();
        }
        
        public function onTick()
        {
            if (!_playerOrb) return;
            if (!_gameRunning) return;
        
            var playerActor = _playerOrb.lookupComponentByName("actor") as ActorComponent;
            var playerBehavior = _playerOrb.lookupComponentByName("behavior") as PlayerOrbComponent;
            var orbActor:ActorComponent = null;
            
            // Iterate over orbs and handle any collisions with the player
            for each (var orb in _orbs)
            {
                orbActor = orb.lookupComponentByName("actor") as ActorComponent;
                if (playerActor.collidesWithComponent(orbActor))
                {
                    playerBehavior.handleCollisionWithOrb(orb);
                }
            }
            
            // Update how much time has passed
            var time:int = Platform.getTime();
            _survivalTime = time - _gameStartTime;
            
            if (_survivalTime > _bestTime)
            {
                _bestTime = _survivalTime;
            }
            
            if (_playerGettingHurt)
            {
                var elapsedThisFrame = time - _playerHurtPreviousTime;
                _timeUntilDeath = Math.max(0, _timeUntilDeath - elapsedThisFrame);
                _playerHurtPreviousTime = time;
                
                // Game over
                if (_timeUntilDeath == 0)
                {
                    // Stop the game
                    _gameRunning = false;
                    _spawnTimer.stop();
                    
                    CCUserDefault.sharedUserDefault().setIntegerForKey("bestTime", _bestTime);
                    
                    onGameOver(_survivalTime, _bestTime);
                }
            }
            
            onTimeChanged(_survivalTime, _timeUntilDeath, _bestTime);
        }
        
        public function onTouchBegan(id:int, touchX:Number, touchY:Number)
        {
            if (!_playerOrb)
            {
                // Reset timers
                _gameStartTime = Platform.getTime();
                _spawnTimer.start();
                
                // Spawn the player
                spawnPlayerOrb(id, touchX, touchY);
                
                _gameRunning = true;
                onGameBegan();
            }
        }
        
        protected function spawnPlayerOrb(id:int, touchX:Number, touchY:Number)
        {
            var orbObject = new LoomGameObject();
            var orbActor = new ActorComponent();
            var orbRenderer = new RenderComponent();
            var orbBehavior = new PlayerOrbComponent();
            
            orbObject.addComponent(orbActor, "actor");
            orbObject.addComponent(orbRenderer, "renderer");
            orbObject.addComponent(orbBehavior, "behavior");
            
            orbBehavior.onPolarityChanged += onPlayerPolarityChanged;
            
            // TODO: Investigate why setting texture first is necessary for opacity to work
            orbRenderer.addBinding("x", "@actor.x");
            orbRenderer.addBinding("y", "@actor.y");
            orbRenderer.addBinding("texture", "@behavior.texture");
            orbRenderer.addBinding("scale", "@actor.scale");
            orbRenderer.addBinding("r", "@actor.r");
            orbRenderer.addBinding("g", "@actor.g");
            orbRenderer.addBinding("b", "@actor.b");
            orbRenderer.addBinding("opacity", "@actor.opacity");
            
            orbObject.owningGroup = this;
            orbObject.initialize();
            
            _playerOrb = orbObject;
        }
        
        protected function spawnRandomOrb(timer:Timer)
        {
            var orbObject = new LoomGameObject();
            var orbActor = new ActorComponent();
            var orbRenderer = new RenderComponent();
            var orbBehavior = new OrbBehaviorComponent();
            
            orbObject.addComponent(orbActor, "actor");
            orbObject.addComponent(orbRenderer, "renderer");
            orbObject.addComponent(orbBehavior, "behavior");
            
            orbBehavior.onDeath += onOrbDeath;
            
            orbRenderer.addBinding("x", "@actor.x");
            orbRenderer.addBinding("y", "@actor.y");
            orbRenderer.addBinding("texture", "@behavior.texture");
            orbRenderer.addBinding("scale", "@actor.scale");
            orbRenderer.addBinding("opacity", "@actor.opacity");
            
            orbObject.owningGroup = this;
            orbObject.initialize();
            
            _orbs.push(orbObject);
            
            _spawnTimer.start();
        }
        
        protected function onOrbDeath(orbBehavior:OrbBehaviorComponent, object:LoomGameObject)
        {
            orbBehavior.onDeath -= onOrbDeath;
            _orbs.remove(object);
            object.destroy();
        }
        
        public function onPlayerPolarityChanged(polarity:int)
        {
            if (polarity == 0)
            {
                _playerGettingHurt = false;
            }
            else
            {
                _playerGettingHurt = true;
                _playerHurtPreviousTime = Platform.getTime();
            }
            
            onPolarityChanged(polarity);
        }
    }
}