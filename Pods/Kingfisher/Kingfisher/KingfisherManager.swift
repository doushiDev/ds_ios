//
//  KingfisherManager.swift
//  Kingfisher
//
//  Created by Wei Wang on 15/4/6.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public typealias DownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> ())
public typealias CompletionHandler = ((_ image: UIImage?, _ error: NSError?, _ cacheType: CacheType, _ imageURL: URL?) -> ())

/// RetrieveImageTask represents a task of image retrieving process.
/// It contains an async task of getting image from disk and from network.
open class RetrieveImageTask {
    
    // If task is canceled before the download task started (which means the `downloadTask` is nil),
    // the download task should not begin.
    var cancelledBeforeDownlodStarting: Bool = false
    
    /// The disk retrieve task in this image task. Kingfisher will try to look up in cache first. This task represent the cache search task.
    open var diskRetrieveTask: RetrieveImageDiskTask?
    
    /// The network retrieve task in this image task.
    open var downloadTask: RetrieveImageDownloadTask?
    
    /**
    Cancel current task. If this task does not begin or already done, do nothing.
    */
    open func cancel() {
        // From Xcode 7 beta 6, the `dispatch_block_cancel` will crash at runtime.
        // It fixed in Xcode 7.1.
        // See https://github.com/onevcat/Kingfisher/issues/99 for more.
        if let diskRetrieveTask = diskRetrieveTask {
            dispatch_block_cancel(diskRetrieveTask)
        }
        
        if let downloadTask = downloadTask {
            downloadTask.cancel()
        } else {
            cancelledBeforeDownlodStarting = true
        }
    }
}

/// Error domain of Kingfisher
public let KingfisherErrorDomain = "com.onevcat.Kingfisher.Error"

private let instance = KingfisherManager()

/// Main manager class of Kingfisher. It connects Kingfisher downloader and cache.
/// You can use this class to retrieve an image via a specified URL from web or cache.
open class KingfisherManager {

    /// Options to control some downloader and cache behaviors.
    public typealias Options = (forceRefresh: Bool, lowPriority: Bool, cacheMemoryOnly: Bool, shouldDecode: Bool, queue: DispatchQueue?, scale: CGFloat)
    
    /// A preset option tuple with all value set to `false`.
    open static let OptionsNone: Options = {
        return (forceRefresh: false, lowPriority: false, cacheMemoryOnly: false, shouldDecode: false, queue: DispatchQueue.main, scale: 1.0)
    }()
    
    /// The default set of options to be used by the manager to control some downloader and cache behaviors.
    open static var DefaultOptions: Options = OptionsNone
    
    /// Shared manager used by the extensions across Kingfisher.
    open class var sharedManager: KingfisherManager {
        return instance
    }
    
    /// Cache used by this manager
    open var cache: ImageCache
    
    /// Downloader used by this manager
    open var downloader: ImageDownloader
    
    /**
    Default init method
    
    - returns: A Kingfisher manager object with default cache and default downloader.
    */
    public init() {
        cache = ImageCache.defaultCache
        downloader = ImageDownloader.defaultDownloader
    }
    
    /**
    Get an image with resource.
    If KingfisherOptions.None is used as `options`, Kingfisher will seek the image in memory and disk first.
    If not found, it will download the image at `resource.downloadURL` and cache it with `resource.cacheKey`.
    These default behaviors could be adjusted by passing different options. See `KingfisherOptions` for more.
    
    - parameter resource:          Resource object contains information such as `cacheKey` and `downloadURL`.
    - parameter optionsInfo:       A dictionary could control some behaviors. See `KingfisherOptionsInfo` for more.
    - parameter progressBlock:     Called every time downloaded data changed. This could be used as a progress UI.
    - parameter completionHandler: Called when the whole retrieving process finished.
    
    - returns: A `RetrieveImageTask` task object. You can use this object to cancel the task.
    */
    open func retrieveImageWithResource(_ resource: Resource,
        optionsInfo: KingfisherOptionsInfo?,
        progressBlock: DownloadProgressBlock?,
        completionHandler: CompletionHandler?) -> RetrieveImageTask
    {
        let task = RetrieveImageTask()
        
        // There is a bug in Swift compiler which prevents to write `let (options, targetCache) = parseOptionsInfo(optionsInfo)`
        // It will cause a compiler error.
        let parsedOptions = parseOptionsInfo(optionsInfo)
        let (options, targetCache, downloader) = (parsedOptions.0, parsedOptions.1, parsedOptions.2)
        
        if options.forceRefresh {
            downloadAndCacheImageWithURL(resource.downloadURL as URL,
                forKey: resource.cacheKey,
                retrieveImageTask: task,
                progressBlock: progressBlock,
                completionHandler: completionHandler,
                options: options,
                targetCache: targetCache,
                downloader: downloader)
        } else {
            tryToRetrieveImageFromCacheForKey(resource.cacheKey,
                withURL: resource.downloadURL as URL,
                retrieveImageTask: task,
                progressBlock: progressBlock,
                completionHandler: completionHandler,
                options: options,
                targetCache: targetCache,
                downloader: downloader)
        }
        
        return task
    }

    /**
    Get an image with `URL.absoluteString` as the key.
    If KingfisherOptions.None is used as `options`, Kingfisher will seek the image in memory and disk first.
    If not found, it will download the image at URL and cache it with `URL.absoluteString` value as its key.
    
    If you need to specify the key other than `URL.absoluteString`, please use resource version of this API with `resource.cacheKey` set to what you want.
    
    These default behaviors could be adjusted by passing different options. See `KingfisherOptions` for more.
    
    - parameter URL:               The image URL.
    - parameter optionsInfo:       A dictionary could control some behaviors. See `KingfisherOptionsInfo` for more.
    - parameter progressBlock:     Called every time downloaded data changed. This could be used as a progress UI.
    - parameter completionHandler: Called when the whole retrieving process finished.
    
    - returns: A `RetrieveImageTask` task object. You can use this object to cancel the task.
    */
    open func retrieveImageWithURL(_ URL: Foundation.URL,
                             optionsInfo: KingfisherOptionsInfo?,
                           progressBlock: DownloadProgressBlock?,
                       completionHandler: CompletionHandler?) -> RetrieveImageTask
    {
        return retrieveImageWithResource(Resource(downloadURL: URL), optionsInfo: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    func downloadAndCacheImageWithURL(_ URL: Foundation.URL,
                               forKey key: String,
                        retrieveImageTask: RetrieveImageTask,
                            progressBlock: DownloadProgressBlock?,
                        completionHandler: CompletionHandler?,
                                  options: Options,
                              targetCache: ImageCache,
                               downloader: ImageDownloader)
    {
        downloader.downloadImageWithURL(URL, retrieveImageTask: retrieveImageTask, options: options,
            progressBlock: { receivedSize, totalSize in
                progressBlock?(receivedSize: receivedSize, totalSize: totalSize)
            },
            completionHandler: { image, error, imageURL, originalData in

                if let error = error , error.code == KingfisherError.notModified.rawValue {
                    // Not modified. Try to find the image from cache.
                    // (The image should be in cache. It should be guaranteed by the framework users.)
                    targetCache.retrieveImageForKey(key, options: options, completionHandler: { (cacheImage, cacheType) -> () in
                        completionHandler?(image: cacheImage, error: nil, cacheType: cacheType, imageURL: URL)
                        
                    })
                    return
                }
                
                if let image = image, let originalData = originalData {
                    targetCache.storeImage(image, originalData: originalData, forKey: key, toDisk: !options.cacheMemoryOnly, completionHandler: nil)
                }
                
                completionHandler?(image: image, error: error, cacheType: .none, imageURL: URL)
            }
        )
    }
    
    func tryToRetrieveImageFromCacheForKey(_ key: String,
                                   withURL URL: Foundation.URL,
                             retrieveImageTask: RetrieveImageTask,
                                 progressBlock: DownloadProgressBlock?,
                             completionHandler: CompletionHandler?,
                                       options: Options,
                                   targetCache: ImageCache,
                                    downloader: ImageDownloader)
    {
        let diskTaskCompletionHandler: CompletionHandler = { (image, error, cacheType, imageURL) -> () in
            // Break retain cycle created inside diskTask closure below
            retrieveImageTask.diskRetrieveTask = nil
            completionHandler?(image, error, cacheType, imageURL)
        }
        let diskTask = targetCache.retrieveImageForKey(key, options: options,
            completionHandler: { image, cacheType in
                if image != nil {
                    diskTaskCompletionHandler(image: image, error: nil, cacheType:cacheType, imageURL: URL)
                } else {
                    self.downloadAndCacheImageWithURL(URL,
                        forKey: key,
                        retrieveImageTask: retrieveImageTask,
                        progressBlock: progressBlock,
                        completionHandler: diskTaskCompletionHandler,
                        options: options,
                        targetCache: targetCache,
                        downloader: downloader)
                }
            }
        )
        retrieveImageTask.diskRetrieveTask = diskTask
    }
    
    func parseOptionsInfo(_ optionsInfo: KingfisherOptionsInfo?) -> (Options, ImageCache, ImageDownloader) {
        var options = KingfisherManager.DefaultOptions
        var targetCache = self.cache
        var targetDownloader = self.downloader
        
        guard let optionsInfo = optionsInfo else {
            return (options, targetCache, targetDownloader)
        }
        
        if let optionsItem = optionsInfo.kf_firstMatchIgnoringAssociatedValue(.options(.None)), case .options(let optionsInOptionsInfo) = optionsItem {
            
            let queue = optionsInOptionsInfo.contains(KingfisherOptions.BackgroundCallback) ? DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default) : KingfisherManager.DefaultOptions.queue
            let scale = optionsInOptionsInfo.contains(KingfisherOptions.ScreenScale) ? UIScreen.main.scale : KingfisherManager.DefaultOptions.scale
            
            options = (forceRefresh: optionsInOptionsInfo.contains(KingfisherOptions.ForceRefresh),
                lowPriority: optionsInOptionsInfo.contains(KingfisherOptions.LowPriority),
                cacheMemoryOnly: optionsInOptionsInfo.contains(KingfisherOptions.CacheMemoryOnly),
                shouldDecode: optionsInOptionsInfo.contains(KingfisherOptions.BackgroundDecode),
                queue: queue, scale: scale)
        }
        
        if let optionsItem = optionsInfo.kf_firstMatchIgnoringAssociatedValue(.targetCache(self.cache)), case .targetCache(let cache) = optionsItem {
            targetCache = cache
        }
        
        if let optionsItem = optionsInfo.kf_firstMatchIgnoringAssociatedValue(.downloader(self.downloader)), case .downloader(let downloader) = optionsItem {
            targetDownloader = downloader
        }
        
        return (options, targetCache, targetDownloader)
    }
}

// MARK: - Deprecated
public extension KingfisherManager {
    @available(*, deprecated: 1.2, message: "Use -retrieveImageWithURL:optionsInfo:progressBlock:completionHandler: instead.")
    public func retrieveImageWithURL(_ URL: Foundation.URL,
                                 options: KingfisherOptions,
                           progressBlock: DownloadProgressBlock?,
                       completionHandler: CompletionHandler?) -> RetrieveImageTask
    {
        return retrieveImageWithURL(URL, optionsInfo: [.options(options)], progressBlock: progressBlock, completionHandler: completionHandler)
    }
}
