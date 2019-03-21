//
//  FileLoader.swift
//  AvaBuddies
//
//  Created by simon heij on 19/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class FileLoader {
    
    public static func getDataFrom(resource: ResourceFile) -> Data? {
        
        if let filepath = Bundle.main.path(forResource: resource.filename, ofType: resource.filetype) {
            let file: FileHandle? = FileHandle(forReadingAtPath: filepath)
            let data = file?.readDataToEndOfFile()
            return data
        }
        return nil
    }
}
