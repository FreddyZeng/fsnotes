//
//  Markdown.swift
//  FSNotes
//
//  Created by Wonsup Yoon on 05/10/2019.
//  Copyright © 2019 Oleksandr Glushchenko. All rights reserved.
//

import libcmark_gfm

func renderMarkdownHTML(markdown: String) -> String? {
    let markdown = markdown.replacingOccurrences(of: "{{TOC}}", with: "<div id=\"toc\"></div>")
        
    cmark_gfm_core_extensions_ensure_registered()
    
    guard let parser = cmark_parser_new(CMARK_OPT_FOOTNOTES) else { return nil }
    defer { cmark_parser_free(parser) }

    if let ext = cmark_find_syntax_extension("table") {
        cmark_parser_attach_syntax_extension(parser, ext)
    }

    if let ext = cmark_find_syntax_extension("autolink") {
        cmark_parser_attach_syntax_extension(parser, ext)
    }

    if let ext = cmark_find_syntax_extension("strikethrough") {
        cmark_parser_attach_syntax_extension(parser, ext)
    }
    
    if let ext = cmark_find_syntax_extension("tasklist") {
        cmark_parser_attach_syntax_extension(parser, ext)
    }

    cmark_parser_feed(parser, markdown, markdown.utf8.count)
    guard let node = cmark_parser_finish(parser) else { return nil }
    return String(cString: cmark_render_html(node, CMARK_OPT_HARDBREAKS | CMARK_OPT_UNSAFE, nil))
}

func generateAlphabeticalString(length: Int) -> String {
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    var result = "@"
    let length = length - 2

    for _ in 0..<length {
        let randomIndex = Int.random(in: 0..<alphabet.count)
        let randomChar = alphabet[alphabet.index(alphabet.startIndex, offsetBy: randomIndex)]
        result.append(randomChar)
    }

    result.append("@")

    return result
}
