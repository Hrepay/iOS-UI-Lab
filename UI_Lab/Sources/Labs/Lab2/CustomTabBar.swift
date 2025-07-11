//
//  CustomTabBar.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

/*
 UIBezierPath란?
 - UIBezierPath는 iOS에서 벡터 기반의 도형(선, 곡선, 사각형, 원 등)을 그릴 수 있는 클래스입니다.
 - Core Graphics 기반으로 작동하며, UIView나 CALayer 위에 커스텀 경로를 그릴 때 자주 사용됩니다.
 - move(to:), addLine(to:), addCurve(to:) 등을 조합하여 자유로운 형태의 도형을 만들 수 있습니다.
 - 본 파일에서는 하단 탭바(CustomTabBar)의 상단 가운데를 곡선으로 파낸 형태를 UIBezierPath로 정의하여,
   플로팅 버튼이 자연스럽게 탭바 안으로 들어간 것처럼 보이게 구현합니다.
*/
import UIKit

/// 중앙에 float 효과가 적용된 탭바
class CustomTabBar: UITabBar {
    
    // 탭바 모양을 그리는 도형 레이어 저장용
    private var shapeLayer: CALayer?

    // draw(_:) 호출 시 모양을 그림
    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    /// 가운데가 파인 탭바 모양을 그리는 Shape Layer 추가
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath() // UIBezierPath 기반 경로 설정
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        // 그림자 효과
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3

        // 기존 레이어 교체 또는 새로 추가
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    /// UIBezierPath로 가운데가 파인 경로 생성
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - height * 2, y: 0))

        // 왼쪽 → 중심 곡선
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: centerWidth - 30, y: 0),
                      controlPoint2: CGPoint(x: centerWidth - 35, y: height))

        // 중심 → 오른쪽 곡선
        path.addCurve(to: CGPoint(x: centerWidth + height * 2, y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height),
                      controlPoint2: CGPoint(x: centerWidth + 30, y: 0))

        // 우측, 하단, 좌측으로 닫기
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    /// 플로팅 버튼 클릭 등 탭바 바깥 영역도 터치 허용
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 비활성 상태일 경우 무시
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        // 모든 subview를 위에서부터 터치 감지
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            if let result = member.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }
}
