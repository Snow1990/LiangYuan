//
//  Network.swift
//  LiangYuan
//
//  Created by SN on 2017/10/11.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

//
//  Network.swift
//  UTrain
//
//  Created by SN on 15/6/17.
//  Copyright (c) 2015年 Snow. All rights reserved.
//

import Foundation
import Alamofire
/*
//
//@objc public protocol ResponseCollectionSerializable {
//    static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
//}
//extension Alamofire.Request {
//    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
//        let serializer: Serializer = { (request, response, data) in
//            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
//            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
//            if response != nil && JSON != nil {
//                return (T.collection(response: response!, representation: JSON!), nil)
//            } else {
//                return (nil, serializationError)
//            }
//        }
//        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
//            completionHandler(request, response, object as? [T], error)
//        })
//    }
//}
//
//@objc public protocol ResponseObjectSerializable {
//    init(response: NSHTTPURLResponse, representation: AnyObject)
//}
//
//extension DataRequest {
//
//    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T? , NSError?) -> Void) -> Self {
//        let serializer: Serializer = { (request, response, data) in
//            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
//            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
//            if response != nil && JSON != nil {
//                return (T(response: response!, representation: JSON!) , nil)
//            } else {
//                return (nil, serializationError)
//            }
//        }
//        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
//            completionHandler(request, response, object as? T, error)
//        })
//    }
//}

//extension Alamofire.Request {
//    /**
//     创建了一个Image的Serializer
//     */
//
//    public class func ImageResponseSerializer() -> Serializer {
//        return { request, response, data in
//            if data == nil || data?.length == 0 {
//                return (nil, nil)
//            }
//            var serializationError: NSError?
//
//            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
//
//            return (image, serializationError)
//        }
//    }
//    /**
//     Image的处理闭包
//     */
//    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
//        return response(serializer: Request.ImageResponseSerializer(), completionHandler: { request, response, image, error in
//            completionHandler(request, response, image as? UIImage, error)
//        })
//    }
//
//}
 */
enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case imageSerialization(error: String)
}

extension DataRequest {
    static func imageResponseSerializer() -> DataResponseSerializer<UIImage> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            
            guard case let .success(validData) = result else {
                return .failure(BackendError.dataSerialization(error: result.error as! AFError))
            }
            
            guard let image = UIImage(data: validData, scale: UIScreen.main.scale) else {
                return .failure(BackendError.imageSerialization(error: "数据无法被序列化，因为接收到的数据为空"))
            }
            
            return .success(image)
        }
    }
    
    @discardableResult
    func responseImage(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UIImage>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.imageResponseSerializer(), completionHandler: completionHandler)
    }
}

struct Network {
    
    
    
    //文件存储
    static let libraryPath = NSHomeDirectory() + "/Library"
    static let ducumentPath = NSHomeDirectory() + "/Documents"
    
    
    static let SDCard = ducumentPath
    // 客户端文件夹包名
    static let DirPath = SDCard + "/mutrain"
    // 客户端图片缓存文件夹包名
    static let ImgPath = DirPath + "/images"
    // 偏好设置文件名
    static let PreferFileName = "mutrain"
    static let PageSize = 20
    // 测试
//    static let Domain = "http://120.78.62.199/elearn/v1/api/"
//    static let Domain = "http://112.74.49.243/elearn/v1/api/"
    // 正式
    static let Domain = "http://www.ytrain.net/elearn/v1/api/"
    // 登陆
    static let Login = Domain + "/ws/app/auth/stu/login"
    // 获取公开课推荐的banner课程
    static let GetBannerCourses = Domain + "/ws/app/public/reco/getBannerCourses"
    // 获取公开课推荐的body课程
    static let GetBodyCourses = Domain + "/ws/app/public/reco/getBodyCourses"
    // 获取单个公开课课程的详细信息
    static let GetPublicCourse = Domain + "/ws/app/public/getCourse"
    // 获取公开课相关推荐课程（共10个）
    static let GetPublicRecommendCourses = Domain + "/ws/app/public/getRecommendCourses"
    // 获取公开课热门搜索课程（共10个）
    static let GetHotSearch = Domain + "/ws/app/public/getHotSearch"
    // 获取公开课课程列表
    static let GetPublicCourses = Domain + "/ws/app/public/getCourses"
    // 获取公开课的课程类型（只包含大类）
    static let GetPublicMaxType = Domain + "/ws/app/public/getMaxType"
    // 获取公开课课程评论列表
    static let PublicComments = Domain + "/ws/app/public/comment/list"
    // 保存公开课课程评论
    static let SavePublicComment = Domain + "/ws/app/public/comment/save"
    // 公开课收藏操作
    static let SavePublicFavourite = Domain + "/ws/app/public/favorites/save"
    // 公开课取消收藏操作
    static let DeletePublicFavourite = Domain + "/ws/app/public/favorites/delete"
    // 获取培训班的课程类型
    static let GetSeriesType = Domain + "/ws/app/series/getType"
    // 获取培训班的系列课列表
    static let GetSeriesCourses = Domain + "/ws/app/series/getSeriesCourses"
    // 获取图片资源
    static let GetImage = Domain + "/file/load"
    
    
    //获取文件路径
//    func getFilePath(fileName:String)->String{
//
//        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        var documentDirectory = path[0] as! String
//        return documentDirectory.stringByAppendingPathComponent(fileName)
//    }
    
}

