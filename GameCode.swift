import Foundation
var barriers: [Shape] = []
var targets: [Shape] = []
let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    targets.append(target)
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    target.isDraggable = false
    scene.add(target)
}

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    ball.onTapped = resetGame
    ball.bounciness = 0.9
    scene.add(ball)
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.fillColor = .brown
    barrier.angle = angle
    scene.add(barrier)
}

fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
    scene.add(funnel)
}

func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

func ballExitedScene() {
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
    for barrier in barriers {
        barrier.isDraggable = true
    }
}

func alertDismissed() {
}

func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    for target in targets {
        target.fillColor = .yellow
    }
}

func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func setup() {
    setupBall()
    
    addBarrier(at: Point(x: 300, y: 150), width: 140, height: 50, angle: 0.3)
    addBarrier(at: Point(x: 100, y: 150), width: 140, height: 50, angle: -0.3)
    addBarrier(at: Point(x: 150, y: 350), width: 100, height: 50, angle: 0.0)
    
    setupFunnel()
    
    addTarget(at: Point(x: 115, y: 400))
    addTarget(at: Point(x: 270, y: 450))
    addTarget(at: Point(x: 370, y: 220))
    addTarget(at: Point(x: 250, y: 350))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}
