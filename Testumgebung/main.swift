//
//  main.swift
//  Testumgebung
//
//  Created by Geordie Jay on 09.01.16.
//  Copyright © 2016 Geordie Jay. All rights reserved.
//

import SDL2

guard SDL_Init(Uint32(SDL_INIT_VIDEO)) == 0 else {
    fatalError("Couldn't init SDL")
}

var displayMode = SDL_DisplayMode() // get display resolution
guard SDL_GetCurrentDisplayMode(0, &displayMode) == 0 else {
    fatalError("Couldn't get current display mode")
}

// Provide a max screen resolution
if displayMode.w > 1280 { displayMode.w = 1280 }
if displayMode.h > 1024 { displayMode.h = 1024 }

let SCREEN_WIDTH = displayMode.w
let SCREEN_HEIGHT = displayMode.h

let window = SDL_CreateWindow("Testumgebung", SDL_WINDOWPOS_UNDEFINED_MASK, SDL_WINDOWPOS_UNDEFINED_MASK, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_OPENGL.rawValue)
guard window != nil else {
   fatalError("Couldn't init window")
}

let renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED.rawValue | SDL_RENDERER_PRESENTVSYNC.rawValue)
guard renderer != nil else {
    fatalError("Couldn't init renderer")
}

SDL_SetRenderDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF)

let ySpacing: Int32 = 20

func createBars() -> [SDL_Rect] {
    let numBars: Int32 = 12
    let numSpaces = numBars + 1

    let xSpacing: Int32 = SCREEN_WIDTH / (numBars + numSpaces) * 2 / 3
    let barWidth: Int32 = xSpacing * 2
    
    return (0 ..< numBars).map { n -> SDL_Rect in
        let height: Int32 = Int32(random() % Int(SCREEN_HEIGHT - ySpacing))
        let x = ((n + 2) * xSpacing) + n * barWidth
        return SDL_Rect(x: x, y: SCREEN_HEIGHT - ySpacing - height, w: barWidth, h: height)
    }
}

func setBarHeights(inout bars: [SDL_Rect]) {
    let newBars = bars.map { (var bar) -> SDL_Rect in
        bar.h = (bar.h + Int32(random() % Int(SCREEN_HEIGHT - ySpacing))) / 2
        bar.y = SCREEN_HEIGHT - ySpacing - bar.h
        return bar
    }
    bars = newBars
}


var bars = createBars()

SDL_UpdateWindowSurface(window)

var e = SDL_Event()
var quit = false

while (!quit) {
    while SDL_PollEvent(&e) != 0 {
         if e.type == SDL_QUIT.rawValue {
            quit = true
        }
    }

    SDL_SetRenderDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF)
    SDL_RenderClear(renderer)
    
    setBarHeights(&bars)

    SDL_SetRenderDrawColor(renderer, 0xFF, 0x70, 0x00, 0xFF)
    SDL_RenderFillRects(renderer, bars, Int32(bars.count))
    SDL_RenderPresent(renderer)
}

SDL_DestroyRenderer(renderer)
SDL_DestroyWindow(window)
SDL_Quit()
