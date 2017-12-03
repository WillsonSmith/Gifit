//
//  utilities.swift
//  Giferize
//
//  Created by Willson Smith on 2015-11-23.
//  Copyright © 2015 Willson Smith. All rights reserved.
//

import Foundation


func runffmpeg(_ uri:String, fps:String, scale:String) -> String {
    let filters = "fps=\(fps),scale=\(scale):-1:flags=lanczos";
    let palette = "/tmp/palette.png";
    let task = Process();
    let ffmpeg = Bundle.main.path(forResource: "ffmpeg", ofType:"")!
    
    var fileSavePath = uri.components(separatedBy: ".").map{String($0)};
    _ = fileSavePath.popLast();
    let fsp = "\((fileSavePath ).joined(separator: "/")).gif";

    task.launchPath = ffmpeg;
    task.arguments = ["-v", "warning", "-i", "\(uri)", "-vf", "\(filters),palettegen", "-y", "\(palette)"];
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    task.waitUntilExit();
    let task2 = Process();
    task2.launchPath = ffmpeg;
    task2.arguments = ["-v", "warning", "-i", "\(uri)", "-i", "\(palette)", "-lavfi", "\(filters) [x]; [x][1:v] paletteuse", "-y", "\(fsp)"];
    task2.launch();
    task.waitUntilExit();

    return "done";
}
