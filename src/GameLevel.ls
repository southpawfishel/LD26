package
{
    import Loom.GameFramework.LoomGameObject;
    import Loom.GameFramework.LoomGroup;
    import Loom.Graphics.Point2;
    
    import cocos2d.ccColor4B;
    import cocos2d.CCLayerColor;
    import cocos2d.CCScaledLayer;
    import cocos2d.CCSpriteBatchNode;
    import cocos2d.CCPoint;
    import cocos2d.CCSize;
    import cocos2d.CCArray;
    import cocos2d.CCDictionary;
    
    public class GameLevel extends LoomGroup
    {
        [Inject]
        private var _rootLayer:CCScaledLayer;
        
        private var _bg:CCLayerColor;
        
        private var _orbs:Vector.<LoomGameObject> = new Vector.<LoomGameObject>();
    
        public function GameLevel()
        {
        }
    
        override public function initialize(objectName:String=null)
        {
            super.initialize(objectName);
            
            var bgColor:ccColor4B = new ccColor4B();
            bgColor.r = 100;
            bgColor.g = 100;
            bgColor.b = 100;
            bgColor.a = 255;
            _bg = CCLayerColor.create(bgColor, _rootLayer.designWidth, _rootLayer.designHeight);
            _rootLayer.addChild(_bg);
            
            var spawnPoint:Point2 = new Point2();
            spawnPoint.x = 240;
            spawnPoint.y = 160;
            var velocity:Point2 = new Point2();
            velocity.x = 50;
            velocity.y = 50;
            spawnOrb(spawnPoint, velocity);
        }
        
        override public function destroy()
        {
            _rootLayer.removeChild(_bg, true);
        
            super.destroy();
        }
        
        protected function spawnOrb(position:Point2, velocity:Point2)
        {
            var orbObject = new LoomGameObject();
            var orbActor = new ActorComponent();
            var orbRenderer = new RenderComponent();
            var orbBehavior = new OrbBehaviorComponent();
            
            orbObject.addComponent(orbActor, "actor");
            orbObject.addComponent(orbRenderer, "renderer");
            orbObject.addComponent(orbBehavior, "behavior");
            
            orbActor.position = position;
            orbActor.velocity = velocity;
            
            orbBehavior.actor = orbActor;
            orbBehavior.texture = "assets/plus.png";
            
            orbRenderer.addBinding("x", "@actor.x");
            orbRenderer.addBinding("y", "@actor.y");
            orbRenderer.addBinding("texture", "@behavior.texture");
            
            orbObject.owningGroup = this;
            orbObject.initialize();
        }
    }
}