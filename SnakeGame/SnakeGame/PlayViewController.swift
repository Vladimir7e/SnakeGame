//
//  PlayViewController.swift
//  SnakeGame
//
//  Created by Developer on 31.08.2022.
//

import UIKit

class PlayViewController: UIViewController {
    
    enum directionSnake {
        case up, down, left, right
    }
    
    private var snakesArray: [UIView] = []
    private var foodView: UIView = UIView()
    let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    private var startPos: CGPoint = .zero
    private var isStarted: Bool = true
    private var gameOver: Bool = false
    private var startDirectionSnake = directionSnake.left
    private var posArray: [CGPoint] = [CGPoint(x: 40, y: 0), CGPoint(x: 20, y: 0), CGPoint(x: 0, y: 0)]
    private var foodPos: CGPoint = CGPoint(x: 0, y: 0)
    private let snakeSize: CGFloat = 20
    private var timer: Timer?

    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let minY = UIScreen.main.bounds.minY
    let maxY = UIScreen.main.bounds.maxY

    // MARK: - Base overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Private

    private func setupUIElements() {
        setupStartSnake()
        setupFood()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(panGestureRecognizer)
        view.translatesAutoresizingMaskIntoConstraints = false
   }

    private func setupStartSnake() {
        setupSnakeView(index: 0)
        setupSnakeView(index: 1)
        setupSnakeView(index: 2)
//        posArray[0] = getRandomPosition()
    }

    private func setupSnakeView(index: Int) {
        let snakeView: UIView = UIView(frame: CGRect(origin: posArray[index], size: CGSize(width: snakeSize, height: snakeSize)))
        snakesArray.append(snakeView)
        view.addSubview(snakeView)
        snakeView.setNeedsLayout()
        snakeView.layoutSubviews()
        snakeView.layoutIfNeeded()
        snakeView.backgroundColor = .green
        snakeView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupFood() {
        foodPos = getRandomPosition()
        foodView = UIView(frame: CGRect(origin: foodPos, size: CGSize(width: snakeSize, height: snakeSize)))
        foodView.backgroundColor = .systemRed
        foodView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foodView)
    }

    private func getRandomPosition() -> CGPoint {
        let rows = Int(maxX/snakeSize)
        let cols = Int(maxY/snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        let randomY = Int.random(in: 1..<cols) * Int(snakeSize)
        
        return CGPoint(x: randomX, y: randomY)
    }

    private func changeDirection () {
        checkGameOver()
        let prev: CGPoint = posArray[0]
        setupFirstSnakesElement()
        updateSnake(with: prev)
    }

    private func checkGameOver() {
        if posArray[0].x < minX || posArray[0].x > maxX && !gameOver {
            gameOver = !gameOver
        }
        else if posArray[0].y < minY || posArray[0].y > maxY  && !gameOver {
            gameOver = !gameOver
        }
    }

    private func setupFirstSnakesElement() {
        if startDirectionSnake == .down {
            posArray[0].y += snakeSize
        } else if startDirectionSnake == .up {
            posArray[0].y -= snakeSize
        } else if startDirectionSnake == .left {
            posArray[0].x += snakeSize
        } else {
            posArray[0].x -= snakeSize
        }

        snakeMoveWith(0)
    }

    private func updateSnake(with prev: CGPoint) {
        var prev: CGPoint = prev
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
            snakeMoveWith(index)
        }
    }

    private func snakeMoveWith(_ index: Int) {
        snakesArray[index].frame.origin = posArray[index]
    }

    // MARK: - Objc funcs

    @objc func tick(_ timer: Timer) {
        if !gameOver {
            changeDirection()
            if posArray[0] == foodPos {
                posArray.append(posArray[0])
                setupSnakeView(index: 0)
                foodPos = getRandomPosition()
                foodView.frame.origin = self.foodPos
            }
        } else {
            timer.invalidate()
            print("Game Over")
        }
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        if isStarted {
            startPos = sender.location(in: view)
        }
        
        let xDist = abs(sender.location(in: view).x - startPos.x)
        let yDist = abs(sender.location(in: view).y - startPos.y)
        
        if startPos.y < sender.location(in: view).y && yDist > xDist {
            startDirectionSnake = directionSnake.down
        }
        else if startPos.y > sender.location(in: view).y && yDist > xDist {
            startDirectionSnake = directionSnake.up
        }
        else if startPos.x > sender.location(in: view).x && yDist < xDist {
            startDirectionSnake = directionSnake.right
        }
        else if startPos.x < sender.location(in: view).x && yDist < xDist {
            startDirectionSnake = directionSnake.left
        }
        isStarted = !isStarted
    }
}
