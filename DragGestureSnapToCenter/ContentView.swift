//
//  DragGestureSnapIfSlow.swift
//  SaudLearning
//
//  Created by SaudAlhafith on 18/01/1445 AH.
//


/*
 DRAG GESTURE - SNAP TO CENTER FEATURE: General Information
    - This project IS NOT for use, but for learning
    - and it it NOT ready to use in your project
    - You need to recreate it in a way that will fit in your APP.
*/
import SwiftUI


struct DragGestureSnapToCenter: View {
    
    @State private var curPos: CGSize = CGSize(width: 100, height: 200)
    @State private var prevPos: CGSize = CGSize(width: 100, height: 200)
    
    @State private var verticalCentered: Bool = false
    @State private var verticalTimer: Int = 0
    @State private var horizontalCentered: Bool = false
    @State private var horizontalTimer: Int = 0
    
    @State private var countingTimer: Timer?
    
    let TimeToSnap: Int = 1
    let areaSize: Double = 20
    
    var body: some View {
        ZStack(alignment: .center){
            Color.white
            ZStack(alignment: .center){
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300, height: 500)
                    .overlay {
                        Rectangle()
                            .fill(Color.red.opacity(0.2))
                            .frame(maxWidth: .infinity, maxHeight: areaSize)
                        Rectangle()
                            .fill(Color.red.opacity(0.2))
                            .frame(maxWidth: areaSize, maxHeight: .infinity)
                    }
                    .overlay {
                        Rectangle()
                            .fill(horizontalCentered ? Color.blue : Color.clear)
                            .frame(maxWidth: .infinity, maxHeight: 2)
                        Rectangle()
                            .fill(verticalCentered ? Color.blue : Color.clear)
                            .frame(maxWidth: 2, maxHeight: .infinity)
                    }
                GeometryReader { value in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Rectangle()
                                .fill(Color.red.opacity(0.2))
                                .frame(maxWidth: .infinity, maxHeight: areaSize)
                            Rectangle()
                                .fill(Color.red.opacity(0.2))
                                .frame(maxWidth: areaSize, maxHeight: .infinity)
                        }
                        .offset(curPos)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.default){
                                        // move the rectangle
                                        curPos = allowedArea(elementLocation: value.translation.addCGSizeTo(other: prevPos), curLocation: .zero)
                                        
                                        // check if the rectangle at horizontal or vertical Axis
                                        verticalCentered = checkIfVerticallyCentered(elementLocation: &curPos)
                                        horizontalCentered = checkIfHorizontallyCentered(elementLocation: &curPos)
                                        
                                        if countingTimer?.isValid == false || countingTimer == nil{
                                            countingTimer = timerFunction()
                                        }
                                    }
                                })
                                .onEnded({ value in
                                    withAnimation(.default){
                                        prevPos = allowedArea(elementLocation: curPos, curLocation: .zero)
                                        verticalCentered = false
                                        horizontalCentered = false
                                        countingTimer?.invalidate()
                                        horizontalTimer = 0
                                        verticalTimer = 0
                                    }
                                })
                        )
                }
            }
            .offset(y: 40)
            .fixedSize()
            VStack(alignment: .leading){
                Text("Element Location : (\(curPos.width, specifier: "%.2f"), \(curPos.height, specifier: "%.2f"))")
                Text("vertical Timer : \(verticalTimer)")
                Text("horizontal Timer : \(horizontalTimer)")
                Text("Sanpping Vertically : \(verticalCentered ? "✅" : "❌")")
                Text("Sanpping Horizontally : \(horizontalCentered ? "✅" : "❌")")
                Text("Needed Time To Snap : \(TimeToSnap)")
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding()
    }
    
    func timerFunction() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if abs(curPos.width - 100) <= areaSize {
                verticalTimer = (verticalTimer + 1)
            } else {
                verticalTimer = 0
            }
            if abs(curPos.height - 200) <= areaSize {
                horizontalTimer =  (horizontalTimer + 1)
            } else {
                horizontalTimer = 0
            }
        })
        
    }
    
    func checkIfVerticallyCentered(elementLocation: inout CGSize) -> Bool {
        if abs(elementLocation.width - 100) <= areaSize && verticalTimer >= TimeToSnap {
            elementLocation.width = 100
            return true
        } else if abs(elementLocation.width - 100) > areaSize {
            verticalTimer = 0
        }
        return false
    }
    
    func checkIfHorizontallyCentered(elementLocation: inout CGSize) -> Bool {
        if abs(elementLocation.height - 200) <= areaSize && horizontalTimer >= TimeToSnap {
            elementLocation.height = 200
            return true
        } else if abs(elementLocation.height - 200) > areaSize {
            horizontalTimer = 0
        }
        return false
    }
    
    func allowedArea(elementLocation: CGSize, curLocation: CGSize) -> CGSize {
        var newLocation = elementLocation
        
        switch newLocation {
        case let c where c.width > 200 :
            newLocation.width = 200
            print("Width more than 200")
        case let c where c.width < 0 :
            newLocation.width = 0
            print("Width less than 0")
        default :
            break
        }
        
        switch newLocation {
        case let c where c.height > 400 :
            newLocation.height = 400
            print("Height more than 400")
        case let c where c.height < 0 :
            newLocation.height = 0
            print("Height less than 0")
        default :
            break
        }
        
        return newLocation.addCGSizeTo(other: curLocation)
    }
    
}

extension CGSize {
    func addCGSizeTo(other: CGSize) -> CGSize {
        return CGSize(width: self.width + other.width, height: self.height + other.height)
    }
}

struct DragGesture_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureSnapToCenter()
    }
}
