//
//  NoteEditorViewController.swift
//  SwiftTextKitNotepad
//
//  Created by 张银龙 on 2019/3/5.
//  Copyright © 2019 张银龙. All rights reserved.
//


import UIKit

class NoteEditorViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        setupSubviews()
    }
    
    func setupSubviews()  {
        
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        view.addSubview(textView)
        textView.frame = view.bounds
        
        timeView = TimeIndicatorView(date: note.timestamp)
        textView.addSubview(timeView)
    }
    
    override func viewDidLayoutSubviews() {
        
        timeView.updateSize()
        timeView.frame = timeView.frame.offsetBy(dx: textView.frame.width - timeView.frame.width, dy: 0)
        // 文字围绕图片(排除路径)
        let exclusionPath = timeView.curvePathWithOrigin(timeView.center)
        textView.textContainer.exclusionPaths = [exclusionPath]
        
        textStorage.update()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Notification
    
    func updateTextViewSizeForKeyboardHeight(keyboardHeight: CGFloat) {
        textView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let rectValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardSize = rectValue.cgRectValue.size
            updateTextViewSizeForKeyboardHeight(keyboardHeight: keyboardSize.height)
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        updateTextViewSizeForKeyboardHeight(keyboardHeight: 0)
    }
    
    
    // MARK: - property
    
    var note: Note!
    
    
    lazy var textStorage : SyntaxHighlightTextStorage = { [weak self] in
        
        let textStorage = SyntaxHighlightTextStorage()
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let attrString = NSAttributedString(string: note.contents, attributes: attrs)
        textStorage.append(attrString)
        
        return textStorage
    }()
    
    lazy var layoutManager : NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        return layoutManager
    }()
    
    lazy var textView : UITextView = { [weak self] in
        
        let textView = UITextView(frame: .zero, textContainer: container)
        textView.delegate = self
        
        return textView
    }()
    
    lazy var container : NSTextContainer = { [weak self] in
        
        let newTextViewRect = view.bounds
        let containerSize = CGSize(width: newTextViewRect.width,
                                   height: .greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        
        return container
    }()
    
    var timeView: TimeIndicatorView!
    
    
}

// MARK: - UITextViewDelegate
extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.contents = textView.text
    }
}
