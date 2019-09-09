//
//  Layout.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/16/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit

enum colorFor {
    case color
    case shadow
}

extension EditorView {
    
    
    
    
    
    func layout() {
        
        /// deleteView
        view.addSubview(deleteView)
        deleteView.isHidden = true
    
        
        view.addSubview(TopView)
        view.addSubview(BottomView)
        view.addSubview(LayersViews)
        
      
        
        view.addSubview(rotateViews)
        rotateViews.isHidden = true
        
        

        view.addSubview(EdeiterView)
        EdeiterView.isHidden = true
        
        
        view.addSubview(ColorViews)
        ColorViews.isHidden = true
        
        view.addSubview(opacityViews)
        opacityViews.isHidden = true
        
        view.addSubview(TextBackgroundViews)
        TextBackgroundViews.isHidden = true
        

        view.addSubview(FiltersView)
        FiltersView.isHidden = true
        
        view.addSubview(textStylesTools)
        textStylesTools.isHidden = true
        
        
        
        
        view.addSubview(scaleViews)
        scaleViews.isHidden = true
        
        view.addSubview(positionsView)
        positionsView.isHidden = true
        
        
        view.addSubview(DoneButton)
        DoneButton.isHidden = true
        
        view.addSubview(FontViews)
        FontViews.isHidden = true
        
        view.addSubview(TextAlignmenViews)
        TextAlignmenViews.isHidden = true

        view.addSubview(CapsViews)
        CapsViews.isHidden = true
        
        
        view.addSubview(spaceViews)
        spaceViews.isHidden = true

        
        
        view.addSubview(cornerRadiusViews)
        cornerRadiusViews.isHidden = true

        
        
        
        view.addSubview(MaskViews)
        MaskViews.isHidden = true
        
        
        view.addSubview(shadowViews)
        shadowViews.isHidden = true
        
        
        view.addSubview(shapeTools)
        shapeTools.isHidden = true
        
        view.addSubview(imageTool)
        imageTool.isHidden = true
        
        view.addSubview(TextTools)
        TextTools.isHidden = true
        
        view.addSubview(shadowTool)
        shadowTool.isHidden = true
        
        view.addSubview(textBackgroundTools)
        textBackgroundTools.isHidden = true
        
        view.addSubview(cornerRadiusTools)
        cornerRadiusTools.isHidden = true
        
        
        
    
        view.addSubview(CanvasView)
        CanvasView.addSubview(tempImageView)
        
        
        CanvasView.addSubview(LineX)
        CanvasView.addSubview(LineY)
        
        LineX.isHidden = true
        LineY.isHidden = true
        
        
        self.LayersViewHeight = LayersViews.heightAnchor.constraint(equalToConstant: 35)
        self.EdeiterViewHeight =  EdeiterView.heightAnchor.constraint(equalToConstant: 0)
        self.shadowViewsHeight = shadowViews.heightAnchor.constraint(equalToConstant: 0)
        self.ColorViewsBottomAnchor = ColorViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor)
        NSLayoutConstraint.activate([
            
            // TopView layout
            TopView.heightAnchor.constraint(equalToConstant: 50),
            TopView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            TopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            DoneButton.heightAnchor.constraint(equalToConstant: 28),
            DoneButton.widthAnchor.constraint(equalToConstant: 75),
            DoneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            DoneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            
            
            // ColorView layout
            ColorViews.heightAnchor.constraint(equalToConstant: 55),
            ColorViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            ColorViewsBottomAnchor,
            
           
            TextAlignmenViews.heightAnchor.constraint(equalToConstant: 60),
            TextAlignmenViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            TextAlignmenViews.bottomAnchor.constraint(equalTo: textStylesTools.topAnchor),
            
            CapsViews.heightAnchor.constraint(equalToConstant: 60),
            CapsViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            CapsViews.bottomAnchor.constraint(equalTo: textStylesTools.topAnchor),
            
            
            
            
            spaceViews.heightAnchor.constraint(equalToConstant: 55),
            spaceViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            spaceViews.bottomAnchor.constraint(equalTo: textStylesTools.topAnchor),
            
            
            
            shadowViewsHeight,
            shadowViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            shadowViews.bottomAnchor.constraint(equalTo: shadowTool.topAnchor),
            
            
            shadowTool.heightAnchor.constraint(equalToConstant: 50),
            shadowTool.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            shadowTool.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            textStylesTools.heightAnchor.constraint(equalToConstant: 50),
            textStylesTools.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            textStylesTools.bottomAnchor.constraint(equalTo: TextTools.topAnchor),
            

            
            
            FontViews.heightAnchor.constraint(equalToConstant: 60),
            FontViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            FontViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            MaskViews.heightAnchor.constraint(equalToConstant: 80),
            MaskViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            MaskViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            
            opacityViews.heightAnchor.constraint(equalToConstant: 55),
            opacityViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            opacityViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            TextBackgroundViews.heightAnchor.constraint(equalToConstant: 55),
            TextBackgroundViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            TextBackgroundViews.bottomAnchor.constraint(equalTo: textBackgroundTools.topAnchor),
            
            
            cornerRadiusViews.heightAnchor.constraint(equalToConstant: 55),
            cornerRadiusViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            cornerRadiusViews.bottomAnchor.constraint(equalTo: cornerRadiusTools.topAnchor),
            
            
            
            
            
            scaleViews.heightAnchor.constraint(equalToConstant: 50),
            scaleViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            scaleViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            
            
            rotateViews.heightAnchor.constraint(equalToConstant: 111),
            rotateViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            rotateViews.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            positionsView.heightAnchor.constraint(equalToConstant: 70),
            positionsView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            positionsView.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            
            
            FiltersView.heightAnchor.constraint(equalToConstant: 60),
            FiltersView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            FiltersView.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            textBackgroundTools.heightAnchor.constraint(equalToConstant: 70),
            textBackgroundTools.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            textBackgroundTools.bottomAnchor.constraint(equalTo: TextTools.topAnchor),
            
            
            cornerRadiusTools.heightAnchor.constraint(equalToConstant: 70),
            cornerRadiusTools.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            cornerRadiusTools.bottomAnchor.constraint(equalTo: TextTools.topAnchor),
            
            
            
            
            shapeTools.heightAnchor.constraint(equalToConstant: 70),
            shapeTools.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            shapeTools.bottomAnchor.constraint(equalTo: LayersViews.topAnchor),
            
            TextTools.heightAnchor.constraint(equalToConstant: 70),
            TextTools.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            TextTools.bottomAnchor.constraint(equalTo: LayersViews.topAnchor),
            
           
            
            
            
            
            
            imageTool.heightAnchor.constraint(equalToConstant: 70),
            imageTool.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            imageTool.bottomAnchor.constraint(equalTo: LayersViews.topAnchor),
            
          
         
            // LayersViews layout
            LayersViewHeight,
            LayersViews.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            LayersViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // BottomView layout
            BottomView.heightAnchor.constraint(equalToConstant: 70),
            BottomView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            BottomView.bottomAnchor.constraint(equalTo: LayersViews.topAnchor),
            
            // EdeiterView layout
            EdeiterViewHeight,
            EdeiterView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            EdeiterView.bottomAnchor.constraint(equalTo: shapeTools.topAnchor),
            
            
            // CanvasView layout
            CanvasView.heightAnchor.constraint(equalToConstant: self.view.frame.size.width),
            CanvasView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            CanvasView.bottomAnchor.constraint(equalTo: EdeiterView.topAnchor,constant: 0),
            
            
            
            // tempImageView layout
            tempImageView.leadingAnchor.constraint(equalTo: CanvasView.leadingAnchor),
            tempImageView.trailingAnchor.constraint(equalTo: CanvasView.trailingAnchor),
            tempImageView.bottomAnchor.constraint(equalTo: CanvasView.bottomAnchor),
            tempImageView.topAnchor.constraint(equalTo: CanvasView.topAnchor),
            
            //  LineX and LineY layout
            LineX.heightAnchor.constraint(equalToConstant: 1),
            LineX.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            LineX.centerXAnchor.constraint(equalTo: self.CanvasView.centerXAnchor),
            LineX.centerYAnchor.constraint(equalTo: self.CanvasView.centerYAnchor),
           
            LineY.heightAnchor.constraint(equalToConstant: self.view.frame.size.width),
            LineY.widthAnchor.constraint(equalToConstant: 1),
            LineY.centerXAnchor.constraint(equalTo: self.CanvasView.centerXAnchor),
            LineY.centerYAnchor.constraint(equalTo: self.CanvasView.centerYAnchor),
            
            
            
            
            
           // deleteView layout
            deleteView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor,constant: -4),
            deleteView.heightAnchor.constraint(equalToConstant: 50),
            deleteView.widthAnchor.constraint(equalToConstant: 50),
            deleteView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            
            ])
        
    }
    
}
