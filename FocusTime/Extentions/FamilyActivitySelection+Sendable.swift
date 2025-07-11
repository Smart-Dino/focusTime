//
//  FamilyActivitySelection+Sendable.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation
import FamilyControls

// The decision to make this to be @unchecked sendable was tough but in the end I decided to do it.
// This will be more convenient for us to use the original FamilyActivitySelection in places where we mutate it,
// without having lots of boilerplate code to convert it from and to our custom sendable object.
// And besides that, even when I create a custom sendable object - it has to have two Sets with tokens,
// and those tokens aren't Sendable either, which means I will have to import ManagedSettings with a
// @preconcurrency import.
// All of that leads me to believe there is no safe way of passing there around in any form,
// I can only hope it is safe, since FamilyActivitySelection is a struct and the tokens it carries are
// structs as well.
// It may have some supporting code inside which I do not know of and which make this structure non-sendable,
// but for now it is what it is...
extension FamilyActivitySelection: @retroactive @unchecked Sendable { }
