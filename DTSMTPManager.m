//
//  DTSMTPManager.m
//  DTEN
//
//  Created by 东途 on 16/7/6.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "DTSMTPManager.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface DTSMTPManager() <SKPSMTPMessageDelegate>

@end

@implementation DTSMTPManager

+ (instancetype)sharedManager {
    
    static DTSMTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DTSMTPManager alloc]init];
    });
    return manager;
}

- (void)sendWithSenderID:(NSString *)dtenID recive:(NSString *)toEmail path:(NSString *)path {
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    //发送者
    testMsg.fromEmail = dtenID;
    //发送给
    testMsg.toEmail = toEmail;
    //抄送联系人列表，如：@"664742641@qq.com;1@qq.com;2@q.com;3@qq.com"
    //    testMsg.ccEmail = @"lanyuu@live.cn";
    //密送联系人列表，如：@"664742641@qq.com;1@qq.com;2@q.com;3@qq.com"
    //    testMsg.bccEmail = @"664742641@qq.com";
    //发送有些的发送服务器地址
    testMsg.relayHost = @"email-smtp.us-east-1.amazonaws.com";
    //需要鉴权
    testMsg.requiresAuth = YES;
    //发送者的登录账号
    testMsg.login = @"AKIAJKB5INRRXMQXWS5A";
    //发送者的登录密码
    testMsg.pass = @"Ah1KzCwxybf+k5Kk4H8ULNn84pTxjzN8MzVy/OgViszl";
    //邮件主题
    testMsg.subject = [NSString stringWithCString:"This is the mail from your DTEn device" encoding:NSUTF8StringEncoding ];
    
    testMsg.relayPorts = @[@25];
    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    //主题
    NSString *content = @"This is the mail from your DTEN device, please refer to the attachment.";
    NSDictionary *plainPart = @{
                                kSKPSMTPPartContentTypeKey : @"text/plain",
                                kSKPSMTPPartMessageKey : content,
                                kSKPSMTPPartContentTransferEncodingKey : @"8bit"
                                };
    
    
    /** 格式：
     
     *  video/quicktime
     *  text/directory
     *  image/jpg
     *  application/pdf
     
     *  kSKPSMTPPartContentTypeKey:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.vcf\""
     *  kSKPSMTPPartContentDispositionKey:@"attachment;\r\n\tfilename=\"video.mov\""
     
     */
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSString *name = [path lastPathComponent];
    
    NSString *type = [NSString stringWithFormat:@".%@", [name pathExtension]];
    
    // @"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"video.jpg\""
    NSString *typeKey = [NSString stringWithFormat:@"%@;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"", [self formatType:type], name];
    
    // @"attachment;\r\n\tfilename=\"video.jpg\""
    NSString *dispositionKey = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"", name];
    
    NSDictionary *vcfPart = @{
                              kSKPSMTPPartContentTypeKey : typeKey,
                              kSKPSMTPPartContentDispositionKey : dispositionKey,
                              kSKPSMTPPartMessageKey : [data encodeBase64ForData],
                              kSKPSMTPPartContentTransferEncodingKey : @"base64"
                              };
    
    testMsg.parts = @[plainPart, vcfPart];
    
    [testMsg send];
}

- (void)messageSent:(SKPSMTPMessage *)message {
    
    self.sentSuccess();
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    
    self.sentFailure(error);
}

- (NSString *)formatType:(NSString *)type {
    
    if ([type caseInsensitiveCompare:@".3gp"]  == NSOrderedSame) {
        
        return @"video/3gpp";
    }
    else if ([type caseInsensitiveCompare:@".3gpp"]  == NSOrderedSame) {
        
        return @"video/3gpp";
    }
    else if ([type caseInsensitiveCompare:@".aac"]  == NSOrderedSame) {
        
        return @"audio/x-mpeg";}
    else if ([type caseInsensitiveCompare:@".amr"]  == NSOrderedSame) {
        
        return @"audio/x-mpeg";}
    else if ([type caseInsensitiveCompare:@".apk"]  == NSOrderedSame) {
        
        return @"application/vnd.android.package-archive";}
    else if ([type caseInsensitiveCompare:@".avi"]  == NSOrderedSame) {
        
        return @"video/x-msvideo";}
    else if ([type caseInsensitiveCompare:@".aab"]  == NSOrderedSame) {
        
        return @"application/x-authoware-bin";}
    else if ([type caseInsensitiveCompare:@".aam"]  == NSOrderedSame) {
        
        return @"application/x-authoware-map";}
    else if ([type caseInsensitiveCompare:@".aas"]  == NSOrderedSame) {
        
        return @"application/x-authoware-seg";}
    else if ([type caseInsensitiveCompare:@".ai"]  == NSOrderedSame) {
        
        return @"application/postscript";}
    else if ([type caseInsensitiveCompare:@".aif"]  == NSOrderedSame) {
        
        return @"audio/x-aiff";}
    else if ([type caseInsensitiveCompare:@".aifc"]  == NSOrderedSame) {
        
        return @"audio/x-aiff";}
    else if ([type caseInsensitiveCompare:@".aiff"]  == NSOrderedSame) {
        
        return @"audio/x-aiff";}
    else if ([type caseInsensitiveCompare:@".als"]  == NSOrderedSame) {
        
        return @"audio/x-alpha5";}
    else if ([type caseInsensitiveCompare:@".amc"]  == NSOrderedSame) {
        
        return @"application/x-mpeg";}
    else if ([type caseInsensitiveCompare:@".ani"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".asc"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".asd"]  == NSOrderedSame) {
        
        return @"application/astound";}
    else if ([type caseInsensitiveCompare:@".asf"]  == NSOrderedSame) {
        
        return @"video/x-ms-asf";}
    else if ([type caseInsensitiveCompare:@".asn"]  == NSOrderedSame) {
        
        return @"application/astound";}
    else if ([type caseInsensitiveCompare:@".asp"]  == NSOrderedSame) {
        
        return @"application/x-asap";}
    else if ([type caseInsensitiveCompare:@".asx"]  == NSOrderedSame) {
        
        return @" video/x-ms-asf";}
    else if ([type caseInsensitiveCompare:@".au"]  == NSOrderedSame) {
        
        return @"audio/basic";}
    else if ([type caseInsensitiveCompare:@".avb"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".awb"]  == NSOrderedSame) {
        
        return @"audio/amr-wb";}
    else if ([type caseInsensitiveCompare:@".bcpio"]  == NSOrderedSame) {
        
        return @"application/x-bcpio";}
    else if ([type caseInsensitiveCompare:@".bld"]  == NSOrderedSame) {
        
        return @"application/bld";}
    else if ([type caseInsensitiveCompare:@".bld2"]  == NSOrderedSame) {
        
        return @"application/bld2";}
    else if ([type caseInsensitiveCompare:@".bpk"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".bz2"]  == NSOrderedSame) {
        
        return @"application/x-bzip2";}
    else if ([type caseInsensitiveCompare:@".bin"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".bmp"]  == NSOrderedSame) {
        
        return @"image/bmp";}
    else if ([type caseInsensitiveCompare:@".c"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".class"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".conf"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".cpp"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".cal"]  == NSOrderedSame) {
        
        return @"image/x-cals";}
    else if ([type caseInsensitiveCompare:@".ccn"]  == NSOrderedSame) {
        
        return @"application/x-cnc";}
    else if ([type caseInsensitiveCompare:@".cco"]  == NSOrderedSame) {
        
        return @"application/x-cocoa";}
    else if ([type caseInsensitiveCompare:@".cdf"]  == NSOrderedSame) {
        
        return @"application/x-netcdf";}
    else if ([type caseInsensitiveCompare:@".cgi"]  == NSOrderedSame) {
        
        return @"magnus-internal/cgi";}
    else if ([type caseInsensitiveCompare:@".chat"]  == NSOrderedSame) {
        
        return @"application/x-chat";}
    else if ([type caseInsensitiveCompare:@".clp"]  == NSOrderedSame) {
        
        return @"application/x-msclip";}
    else if ([type caseInsensitiveCompare:@".cmx"]  == NSOrderedSame) {
        
        return @"application/x-cmx";}
    else if ([type caseInsensitiveCompare:@".co"]  == NSOrderedSame) {
        
        return @"application/x-cult3d-object";}
    else if ([type caseInsensitiveCompare:@".cod"]  == NSOrderedSame) {
        
        return @"image/cis-cod";}
    else if ([type caseInsensitiveCompare:@".cpio"]  == NSOrderedSame) {
        
        return @"application/x-cpio";}
    else if ([type caseInsensitiveCompare:@".cpt"]  == NSOrderedSame) {
        
        return @"application/mac-compactpro";}
    else if ([type caseInsensitiveCompare:@".crd"]  == NSOrderedSame) {
        
        return @"application/x-mscardfile";}
    else if ([type caseInsensitiveCompare:@".csh"]  == NSOrderedSame) {
        
        return @"application/x-csh";}
    else if ([type caseInsensitiveCompare:@".csm"]  == NSOrderedSame) {
        
        return @"chemical/x-csml";}
    else if ([type caseInsensitiveCompare:@".csml"]  == NSOrderedSame) {
        
        return @"chemical/x-csml";}
    else if ([type caseInsensitiveCompare:@".css"]  == NSOrderedSame) {
        
        return @"text/css";}
    else if ([type caseInsensitiveCompare:@".cur"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".doc"]  == NSOrderedSame) {
        
        return @"application/msword";}
    else if ([type caseInsensitiveCompare:@".docx"]  == NSOrderedSame) {
        
        return @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";}
    else if ([type caseInsensitiveCompare:@".dcm"]  == NSOrderedSame) {
        
        return @"x-lml/x-evm";}
    else if ([type caseInsensitiveCompare:@".dcr"]  == NSOrderedSame) {
        
        return @"application/x-director";}
    else if ([type caseInsensitiveCompare:@".dcx"]  == NSOrderedSame) {
        
        return @"image/x-dcx";}
    else if ([type caseInsensitiveCompare:@".dhtml"]  == NSOrderedSame) {
        
        return @"text/html";}
    else if ([type caseInsensitiveCompare:@".dir"]  == NSOrderedSame) {
        
        return @"application/x-director";}
    else if ([type caseInsensitiveCompare:@".dll"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".dmg"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".dms"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".dot"]  == NSOrderedSame) {
        
        return @"application/x-dot";}
    else if ([type caseInsensitiveCompare:@".dvi"]  == NSOrderedSame) {
        
        return @"application/x-dvi";}
    else if ([type caseInsensitiveCompare:@".dwf"]  == NSOrderedSame) {
        
        return @"drawing/x-dwf";}
    else if ([type caseInsensitiveCompare:@".dwg"]  == NSOrderedSame) {
        
        return @"application/x-autocad";}
    else if ([type caseInsensitiveCompare:@".dxf"]  == NSOrderedSame) {
        
        return @"application/x-autocad";}
    else if ([type caseInsensitiveCompare:@".dxr"]  == NSOrderedSame) {
        
        return @"application/x-director";}
    else if ([type caseInsensitiveCompare:@".ebk"]  == NSOrderedSame) {
        
        return @"application/x-expandedbook";}
    else if ([type caseInsensitiveCompare:@".emb"]  == NSOrderedSame) {
        
        return @"chemical/x-embl-dl-nucleotide";}
    else if ([type caseInsensitiveCompare:@".embl"]  == NSOrderedSame) {
        
        return @"chemical/x-embl-dl-nucleotide";}
    else if ([type caseInsensitiveCompare:@".eps"]  == NSOrderedSame) {
        
        return @"application/postscript";}
    else if ([type caseInsensitiveCompare:@".epub"]  == NSOrderedSame) {
        
        return @"application/epub+zip";}
    else if ([type caseInsensitiveCompare:@".eri"]  == NSOrderedSame) {
        
        return @"image/x-eri";}
    else if ([type caseInsensitiveCompare:@".es"]  == NSOrderedSame) {
        
        return @"audio/echospeech";}
    else if ([type caseInsensitiveCompare:@".esl"]  == NSOrderedSame) {
        
        return @"audio/echospeech";}
    else if ([type caseInsensitiveCompare:@".etc"]  == NSOrderedSame) {
        
        return @"application/x-earthtime";}
    else if ([type caseInsensitiveCompare:@".etx"]  == NSOrderedSame) {
        
        return @"text/x-setext";}
    else if ([type caseInsensitiveCompare:@".evm"]  == NSOrderedSame) {
        
        return @"x-lml/x-evm";}
    else if ([type caseInsensitiveCompare:@".evy"]  == NSOrderedSame) {
        
        return @"application/x-envoy";}
    else if ([type caseInsensitiveCompare:@".exe"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".fh4"]  == NSOrderedSame) {
        
        return @"image/x-freehand";}
    else if ([type caseInsensitiveCompare:@".fh5"]  == NSOrderedSame) {
        
        return @"image/x-freehand";}
    else if ([type caseInsensitiveCompare:@".fhc"]  == NSOrderedSame) {
        
        return @"image/x-freehand";}
    else if ([type caseInsensitiveCompare:@".fif"]  == NSOrderedSame) {
        
        return @"image/fif";}
    else if ([type caseInsensitiveCompare:@".fm"]  == NSOrderedSame) {
        
        return @"application/x-maker";}
    else if ([type caseInsensitiveCompare:@".fpx"]  == NSOrderedSame) {
        
        return @"image/x-fpx";}
    else if ([type caseInsensitiveCompare:@".fvi"]  == NSOrderedSame) {
        
        return @"video/isivideo";}
    else if ([type caseInsensitiveCompare:@".flv"]  == NSOrderedSame) {
        
        return @"video/x-msvideo";}
    else if ([type caseInsensitiveCompare:@".gau"]  == NSOrderedSame) {
        
        return @"chemical/x-gaussian-input";}
    else if ([type caseInsensitiveCompare:@".gca"]  == NSOrderedSame) {
        
        return @"application/x-gca-compressed";}
    else if ([type caseInsensitiveCompare:@".gdb"]  == NSOrderedSame) {
        
        return @"x-lml/x-gdb";}
    else if ([type caseInsensitiveCompare:@".gif"]  == NSOrderedSame) {
        
        return @"image/gif";}
    else if ([type caseInsensitiveCompare:@".gps"]  == NSOrderedSame) {
        
        return @"application/x-gps";}
    else if ([type caseInsensitiveCompare:@".gtar"]  == NSOrderedSame) {
        
        return @"application/x-gtar";}
    else if ([type caseInsensitiveCompare:@".gz"]  == NSOrderedSame) {
        
        return @"application/x-gzip";}
    else if ([type caseInsensitiveCompare:@".gif"]  == NSOrderedSame) {
        
        return @"image/gif";}
    else if ([type caseInsensitiveCompare:@".gtar"]  == NSOrderedSame) {
        
        return @"application/x-gtar";}
    else if ([type caseInsensitiveCompare:@".gz"]  == NSOrderedSame) {
        
        return @"application/x-gzip";}
    else if ([type caseInsensitiveCompare:@".h"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".hdf"]  == NSOrderedSame) {
        
        return @"application/x-hdf";}
    else if ([type caseInsensitiveCompare:@".hdm"]  == NSOrderedSame) {
        
        return @"text/x-hdml";}
    else if ([type caseInsensitiveCompare:@".hdml"]  == NSOrderedSame) {
        
        return @"text/x-hdml";}
    else if ([type caseInsensitiveCompare:@".htm"]  == NSOrderedSame) {
        
        return @"text/html";}
    else if ([type caseInsensitiveCompare:@".html"]  == NSOrderedSame) {
        
        return @"text/html";}
    else if ([type caseInsensitiveCompare:@".hlp"]  == NSOrderedSame) {
        
        return @"application/winhlp";}
    else if ([type caseInsensitiveCompare:@".hqx"]  == NSOrderedSame) {
        
        return @"application/mac-binhex40";}
    else if ([type caseInsensitiveCompare:@".hts"]  == NSOrderedSame) {
        
        return @"text/html";}
    else if ([type caseInsensitiveCompare:@".ice"]  == NSOrderedSame) {
        
        return @"x-conference/x-cooltalk";}
    else if ([type caseInsensitiveCompare:@".ico"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".ief"]  == NSOrderedSame) {
        
        return @"image/ief";}
    else if ([type caseInsensitiveCompare:@".ifm"]  == NSOrderedSame) {
        
        return @"image/gif";}
    else if ([type caseInsensitiveCompare:@".ifs"]  == NSOrderedSame) {
        
        return @"image/ifs";}
    else if ([type caseInsensitiveCompare:@".imy"]  == NSOrderedSame) {
        
        return @"audio/melody";}
    else if ([type caseInsensitiveCompare:@".ins"]  == NSOrderedSame) {
        
        return @"application/x-net-install";}
    else if ([type caseInsensitiveCompare:@".ips"]  == NSOrderedSame) {
        
        return @"application/x-ipscript";}
    else if ([type caseInsensitiveCompare:@".ipx"]  == NSOrderedSame) {
        
        return @"application/x-ipix";}
    else if ([type caseInsensitiveCompare:@".it"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".itz"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".ivr"]  == NSOrderedSame) {
        
        return @"i-world/i-vrml";}
    else if ([type caseInsensitiveCompare:@".j2k"]  == NSOrderedSame) {
        
        return @"image/j2k";}
    else if ([type caseInsensitiveCompare:@".jad"]  == NSOrderedSame) {
        
        return @"text/vnd.sun.j2me.app-descriptor";}
    else if ([type caseInsensitiveCompare:@".jam"]  == NSOrderedSame) {
        
        return @"application/x-jam";}
    else if ([type caseInsensitiveCompare:@".jnlp"]  == NSOrderedSame) {
        
        return @"application/x-java-jnlp-file";}
    else if ([type caseInsensitiveCompare:@".jpe"]  == NSOrderedSame) {
        
        return @"image/jpeg";}
    else if ([type caseInsensitiveCompare:@".jpz"]  == NSOrderedSame) {
        
        return @"image/jpeg";}
    else if ([type caseInsensitiveCompare:@".jwc"]  == NSOrderedSame) {
        
        return @"application/jwc";}
    else if ([type caseInsensitiveCompare:@".jar"]  == NSOrderedSame) {
        
        return @"application/java-archive";}
    else if ([type caseInsensitiveCompare:@".java"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".jpeg"]  == NSOrderedSame) {
        
        return @"image/jpeg";}
    else if ([type caseInsensitiveCompare:@".jpg"]  == NSOrderedSame) {
        
        return @"image/jpeg";}
    else if ([type caseInsensitiveCompare:@".js"]  == NSOrderedSame) {
        
        return @"application/x-javascript";}
    else if ([type caseInsensitiveCompare:@".kjx"]  == NSOrderedSame) {
        
        return @"application/x-kjx";}
    else if ([type caseInsensitiveCompare:@".lak"]  == NSOrderedSame) {
        
        return @"x-lml/x-lak";}
    else if ([type caseInsensitiveCompare:@".latex"]  == NSOrderedSame) {
        
        return @"application/x-latex";}
    else if ([type caseInsensitiveCompare:@".lcc"]  == NSOrderedSame) {
        
        return @"application/fastman";}
    else if ([type caseInsensitiveCompare:@".lcl"]  == NSOrderedSame) {
        
        return @"application/x-digitalloca";}
    else if ([type caseInsensitiveCompare:@".lcr"]  == NSOrderedSame) {
        
        return @"application/x-digitalloca";}
    else if ([type caseInsensitiveCompare:@".lgh"]  == NSOrderedSame) {
        
        return @"application/lgh";}
    else if ([type caseInsensitiveCompare:@".lha"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".lml"]  == NSOrderedSame) {
        
        return @"x-lml/x-lml";}
    else if ([type caseInsensitiveCompare:@".lmlpack"]  == NSOrderedSame) {
        
        return @"x-lml/x-lmlpack";}
    else if ([type caseInsensitiveCompare:@".log"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".lsf"]  == NSOrderedSame) {
        
        return @"video/x-ms-asf";}
    else if ([type caseInsensitiveCompare:@".lsx"]  == NSOrderedSame) {
        
        return @"video/x-ms-asf";}
    else if ([type caseInsensitiveCompare:@".lzh"]  == NSOrderedSame) {
        
        return @"application/x-lzh ";}
    else if ([type caseInsensitiveCompare:@".m13"]  == NSOrderedSame) {
        
        return @"application/x-msmediaview";}
    else if ([type caseInsensitiveCompare:@".m14"]  == NSOrderedSame) {
        
        return @"application/x-msmediaview";}
    else if ([type caseInsensitiveCompare:@".m15"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".m3u"]  == NSOrderedSame) {
        
        return @"audio/x-mpegurl";}
    else if ([type caseInsensitiveCompare:@".m3url"]  == NSOrderedSame) {
        
        return @"audio/x-mpegurl";}
    else if ([type caseInsensitiveCompare:@".ma1"]  == NSOrderedSame) {
        
        return @"audio/ma1";}
    else if ([type caseInsensitiveCompare:@".ma2"]  == NSOrderedSame) {
        
        return @"audio/ma2";}
    else if ([type caseInsensitiveCompare:@".ma3"]  == NSOrderedSame) {
        
        return @"audio/ma3";}
    else if ([type caseInsensitiveCompare:@".ma5"]  == NSOrderedSame) {
        
        return @"audio/ma5";}
    else if ([type caseInsensitiveCompare:@".man"]  == NSOrderedSame) {
        
        return @"application/x-troff-man";}
    else if ([type caseInsensitiveCompare:@".map"]  == NSOrderedSame) {
        
        return @"magnus-internal/imagemap";}
    else if ([type caseInsensitiveCompare:@".mbd"]  == NSOrderedSame) {
        
        return @"application/mbedlet";}
    else if ([type caseInsensitiveCompare:@".mct"]  == NSOrderedSame) {
        
        return @"application/x-mascot";}
    else if ([type caseInsensitiveCompare:@".mdb"]  == NSOrderedSame) {
        
        return @"application/x-msaccess";}
    else if ([type caseInsensitiveCompare:@".mdz"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".me"]  == NSOrderedSame) {
        
        return @"application/x-troff-me";}
    else if ([type caseInsensitiveCompare:@".mel"]  == NSOrderedSame) {
        
        return @"text/x-vmel";}
    else if ([type caseInsensitiveCompare:@".mi"]  == NSOrderedSame) {
        
        return @"application/x-mif";}
    else if ([type caseInsensitiveCompare:@".mid"]  == NSOrderedSame) {
        
        return @"audio/midi";}
    else if ([type caseInsensitiveCompare:@".midi"]  == NSOrderedSame) {
        
        return @"audio/midi";}
    else if ([type caseInsensitiveCompare:@".m4a"]  == NSOrderedSame) {
        
        return @"audio/mp4a-latm";}
    else if ([type caseInsensitiveCompare:@".m4b"]  == NSOrderedSame) {
        
        return @"audio/mp4a-latm";}
    else if ([type caseInsensitiveCompare:@".m4p"]  == NSOrderedSame) {
        
        return @"audio/mp4a-latm";}
    else if ([type caseInsensitiveCompare:@".m4u"]  == NSOrderedSame) {
        
        return @"video/vnd.mpegurl";}
    else if ([type caseInsensitiveCompare:@".m4v"]  == NSOrderedSame) {
        
        return @"video/x-m4v";}
    else if ([type caseInsensitiveCompare:@".mov"]  == NSOrderedSame) {
        
        return @"video/quicktime";}
    else if ([type caseInsensitiveCompare:@".mp2"]  == NSOrderedSame) {
        
        return @"audio/x-mpeg";}
    else if ([type caseInsensitiveCompare:@".mp3"]  == NSOrderedSame) {
        
        return @"audio/x-mpeg";}
    else if ([type caseInsensitiveCompare:@".mp4"]  == NSOrderedSame) {
        
        return @"video/mp4";}
    else if ([type caseInsensitiveCompare:@".mpc"]  == NSOrderedSame) {
        
        return @"application/vnd.mpohun.certificate";}
    else if ([type caseInsensitiveCompare:@".mpe"]  == NSOrderedSame) {
        
        return @"video/mpeg";}
    else if ([type caseInsensitiveCompare:@".mpeg"]  == NSOrderedSame) {
        
        return @"video/mpeg";}
    else if ([type caseInsensitiveCompare:@".mpg"]  == NSOrderedSame) {
        
        return @"video/mpeg";}
    else if ([type caseInsensitiveCompare:@".mpg4"]  == NSOrderedSame) {
        
        return @"video/mp4";}
    else if ([type caseInsensitiveCompare:@".mpga"]  == NSOrderedSame) {
        
        return @"audio/mpeg";}
    else if ([type caseInsensitiveCompare:@".msg"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-outlook";}
    else if ([type caseInsensitiveCompare:@".mif"]  == NSOrderedSame) {
        
        return @"application/x-mif";}
    else if ([type caseInsensitiveCompare:@".mil"]  == NSOrderedSame) {
        
        return @"image/x-cals";}
    else if ([type caseInsensitiveCompare:@".mio"]  == NSOrderedSame) {
        
        return @"audio/x-mio";}
    else if ([type caseInsensitiveCompare:@".mmf"]  == NSOrderedSame) {
        
        return @"application/x-skt-lbs";}
    else if ([type caseInsensitiveCompare:@".mng"]  == NSOrderedSame) {
        
        return @"video/x-mng";}
    else if ([type caseInsensitiveCompare:@".mny"]  == NSOrderedSame) {
        
        return @"application/x-msmoney";}
    else if ([type caseInsensitiveCompare:@".moc"]  == NSOrderedSame) {
        
        return @"application/x-mocha";}
    else if ([type caseInsensitiveCompare:@".mocha"]  == NSOrderedSame) {
        
        return @"application/x-mocha";}
    else if ([type caseInsensitiveCompare:@".mod"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".mof"]  == NSOrderedSame) {
        
        return @"application/x-yumekara";}
    else if ([type caseInsensitiveCompare:@".mol"]  == NSOrderedSame) {
        
        return @"chemical/x-mdl-molfile";}
    else if ([type caseInsensitiveCompare:@".mop"]  == NSOrderedSame) {
        
        return @"chemical/x-mopac-input";}
    else if ([type caseInsensitiveCompare:@".movie"]  == NSOrderedSame) {
        
        return @"video/x-sgi-movie";}
    else if ([type caseInsensitiveCompare:@".mpn"]  == NSOrderedSame) {
        
        return @"application/vnd.mophun.application";}
    else if ([type caseInsensitiveCompare:@".mpp"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-project";}
    else if ([type caseInsensitiveCompare:@".mps"]  == NSOrderedSame) {
        
        return @"application/x-mapserver";}
    else if ([type caseInsensitiveCompare:@".mrl"]  == NSOrderedSame) {
        
        return @"text/x-mrml";}
    else if ([type caseInsensitiveCompare:@".mrm"]  == NSOrderedSame) {
        
        return @"application/x-mrm";}
    else if ([type caseInsensitiveCompare:@".ms"]  == NSOrderedSame) {
        
        return @"application/x-troff-ms";}
    else if ([type caseInsensitiveCompare:@".mts"]  == NSOrderedSame) {
        
        return @"application/metastream";}
    else if ([type caseInsensitiveCompare:@".mtx"]  == NSOrderedSame) {
        
        return @"application/metastream";}
    else if ([type caseInsensitiveCompare:@".mtz"]  == NSOrderedSame) {
        
        return @"application/metastream";}
    else if ([type caseInsensitiveCompare:@".mzv"]  == NSOrderedSame) {
        
        return @"application/metastream";}
    else if ([type caseInsensitiveCompare:@".nar"]  == NSOrderedSame) {
        
        return @"application/zip";}
    else if ([type caseInsensitiveCompare:@".nbmp"]  == NSOrderedSame) {
        
        return @"image/nbmp";}
    else if ([type caseInsensitiveCompare:@".nc"]  == NSOrderedSame) {
        
        return @"application/x-netcdf";}
    else if ([type caseInsensitiveCompare:@".ndb"]  == NSOrderedSame) {
        
        return @"x-lml/x-ndb";}
    else if ([type caseInsensitiveCompare:@".ndwn"]  == NSOrderedSame) {
        
        return @"application/ndwn";}
    else if ([type caseInsensitiveCompare:@".nif"]  == NSOrderedSame) {
        
        return @"application/x-nif";}
    else if ([type caseInsensitiveCompare:@".nmz"]  == NSOrderedSame) {
        
        return @"application/x-scream";}
    else if ([type caseInsensitiveCompare:@".nokia-op-logo"]  == NSOrderedSame) {
        
        return @"image/vnd.nok-oplogo-color";}
    else if ([type caseInsensitiveCompare:@".npx"]  == NSOrderedSame) {
        
        return @"application/x-netfpx";}
    else if ([type caseInsensitiveCompare:@".nsnd"]  == NSOrderedSame) {
        
        return @"audio/nsnd";}
    else if ([type caseInsensitiveCompare:@".nva"]  == NSOrderedSame) {
        
        return @"application/x-neva1";}
    else if ([type caseInsensitiveCompare:@".oda"]  == NSOrderedSame) {
        
        return @"application/oda";}
    else if ([type caseInsensitiveCompare:@".oom"]  == NSOrderedSame) {
        
        return @"application/x-atlasMate-plugin";}
    else if ([type caseInsensitiveCompare:@".ogg"]  == NSOrderedSame) {
        
        return @"audio/ogg";}
    else if ([type caseInsensitiveCompare:@".pac"]  == NSOrderedSame) {
        
        return @"audio/x-pac";}
    else if ([type caseInsensitiveCompare:@".pae"]  == NSOrderedSame) {
        
        return @"audio/x-epac";}
    else if ([type caseInsensitiveCompare:@".pan"]  == NSOrderedSame) {
        
        return @"application/x-pan";}
    else if ([type caseInsensitiveCompare:@".pbm"]  == NSOrderedSame) {
        
        return @"image/x-portable-bitmap";}
    else if ([type caseInsensitiveCompare:@".pcx"]  == NSOrderedSame) {
        
        return @"image/x-pcx";}
    else if ([type caseInsensitiveCompare:@".pda"]  == NSOrderedSame) {
        
        return @"image/x-pda";}
    else if ([type caseInsensitiveCompare:@".pdb"]  == NSOrderedSame) {
        
        return @"chemical/x-pdb";}
    else if ([type caseInsensitiveCompare:@".pdf"]  == NSOrderedSame) {
        
        return @"application/pdf";}
    else if ([type caseInsensitiveCompare:@".pfr"]  == NSOrderedSame) {
        
        return @"application/font-tdpfr";}
    else if ([type caseInsensitiveCompare:@".pgm"]  == NSOrderedSame) {
        
        return @"image/x-portable-graymap";}
    else if ([type caseInsensitiveCompare:@".pict"]  == NSOrderedSame) {
        
        return @"image/x-pict";}
    else if ([type caseInsensitiveCompare:@".pm"]  == NSOrderedSame) {
        
        return @"application/x-perl";}
    else if ([type caseInsensitiveCompare:@".pmd"]  == NSOrderedSame) {
        
        return @"application/x-pmd";}
    else if ([type caseInsensitiveCompare:@".png"]  == NSOrderedSame) {
        
        return @"image/png";}
    else if ([type caseInsensitiveCompare:@".pnm"]  == NSOrderedSame) {
        
        return @"image/x-portable-anymap";}
    else if ([type caseInsensitiveCompare:@".pnz"]  == NSOrderedSame) {
        
        return @"image/png";}
    else if ([type caseInsensitiveCompare:@".pot"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-powerpoint";}
    else if ([type caseInsensitiveCompare:@".ppm"]  == NSOrderedSame) {
        
        return @"image/x-portable-pixmap";}
    else if ([type caseInsensitiveCompare:@".pps"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-powerpoint";}
    else if ([type caseInsensitiveCompare:@".ppt"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-powerpoint";}
    else if ([type caseInsensitiveCompare:@".pptx"]  == NSOrderedSame) {
        
        return @"application/vnd.openxmlformats-officedocument.presentationml.presentation";}
    else if ([type caseInsensitiveCompare:@".pqf"]  == NSOrderedSame) {
        
        return @"application/x-cprplayer";}
    else if ([type caseInsensitiveCompare:@".pqi"]  == NSOrderedSame) {
        
        return @"application/cprplayer";}
    else if ([type caseInsensitiveCompare:@".prc"]  == NSOrderedSame) {
        
        return @"application/x-prc";}
    else if ([type caseInsensitiveCompare:@".proxy"]  == NSOrderedSame) {
        
        return @"application/x-ns-proxy-autoconfig";}
    else if ([type caseInsensitiveCompare:@".prop"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".ps"]  == NSOrderedSame) {
        
        return @"application/postscript";}
    else if ([type caseInsensitiveCompare:@".ptlk"]  == NSOrderedSame) {
        
        return @"application/listenup";}
    else if ([type caseInsensitiveCompare:@".pub"]  == NSOrderedSame) {
        
        return @"application/x-mspublisher";}
    else if ([type caseInsensitiveCompare:@".pvx"]  == NSOrderedSame) {
        
        return @"video/x-pv-pvx";}
    else if ([type caseInsensitiveCompare:@".qcp"]  == NSOrderedSame) {
        
        return @"audio/vnd.qcelp";}
    else if ([type caseInsensitiveCompare:@".qt"]  == NSOrderedSame) {
        
        return @"video/quicktime";}
    else if ([type caseInsensitiveCompare:@".qti"]  == NSOrderedSame) {
        
        return @"image/x-quicktime";}
    else if ([type caseInsensitiveCompare:@".qtif"]  == NSOrderedSame) {
        
        return @"image/x-quicktime";}
    else if ([type caseInsensitiveCompare:@".r3t"]  == NSOrderedSame) {
        
        return @"text/vnd.rn-realtext3d";}
    else if ([type caseInsensitiveCompare:@".ra"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio";}
    else if ([type caseInsensitiveCompare:@".ram"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio";}
    else if ([type caseInsensitiveCompare:@".ras"]  == NSOrderedSame) {
        
        return @"image/x-cmu-raster";}
    else if ([type caseInsensitiveCompare:@".rdf"]  == NSOrderedSame) {
        
        return @"application/rdf+xml";}
    else if ([type caseInsensitiveCompare:@".rf"]  == NSOrderedSame) {
        
        return @"image/vnd.rn-realflash";}
    else if ([type caseInsensitiveCompare:@".rgb"]  == NSOrderedSame) {
        
        return @"image/x-rgb";}
    else if ([type caseInsensitiveCompare:@".rlf"]  == NSOrderedSame) {
        
        return @"application/x-richlink";}
    else if ([type caseInsensitiveCompare:@".rm"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio";}
    else if ([type caseInsensitiveCompare:@".rmf"]  == NSOrderedSame) {
        
        return @"audio/x-rmf";}
    else if ([type caseInsensitiveCompare:@".rmm"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio";}
    else if ([type caseInsensitiveCompare:@".rnx"]  == NSOrderedSame) {
        
        return @"application/vnd.rn-realplayer";}
    else if ([type caseInsensitiveCompare:@".roff"]  == NSOrderedSame) {
        
        return @"application/x-troff";}
    else if ([type caseInsensitiveCompare:@".rp"]  == NSOrderedSame) {
        
        return @"image/vnd.rn-realpix";}
    else if ([type caseInsensitiveCompare:@".rpm"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio-plugin";}
    else if ([type caseInsensitiveCompare:@".rt"]  == NSOrderedSame) {
        
        return @"text/vnd.rn-realtext";}
    else if ([type caseInsensitiveCompare:@".rte"]  == NSOrderedSame) {
        
        return @"x-lml/x-gps";}
    else if ([type caseInsensitiveCompare:@".rtf"]  == NSOrderedSame) {
        
        return @"application/rtf";}
    else if ([type caseInsensitiveCompare:@".rtg"]  == NSOrderedSame) {
        
        return @"application/metastream";}
    else if ([type caseInsensitiveCompare:@".rtx"]  == NSOrderedSame) {
        
        return @"text/richtext";}
    else if ([type caseInsensitiveCompare:@".rv"]  == NSOrderedSame) {
        
        return @"video/vnd.rn-realvideo";}
    else if ([type caseInsensitiveCompare:@".rwc"]  == NSOrderedSame) {
        
        return @"application/x-rogerwilco";}
    else if ([type caseInsensitiveCompare:@".rar"]  == NSOrderedSame) {
        
        return @"application/x-rar-compressed";}
    else if ([type caseInsensitiveCompare:@".rc"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".rmvb"]  == NSOrderedSame) {
        
        return @"audio/x-pn-realaudio";}
    else if ([type caseInsensitiveCompare:@".s3m"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".s3z"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".sca"]  == NSOrderedSame) {
        
        return @"application/x-supercard";}
    else if ([type caseInsensitiveCompare:@".scd"]  == NSOrderedSame) {
        
        return @"application/x-msschedule";}
    else if ([type caseInsensitiveCompare:@".sdf"]  == NSOrderedSame) {
        
        return @"application/e-score";}
    else if ([type caseInsensitiveCompare:@".sea"]  == NSOrderedSame) {
        
        return @"application/x-stuffit";}
    else if ([type caseInsensitiveCompare:@".sgm"]  == NSOrderedSame) {
        
        return @"text/x-sgml";}
    else if ([type caseInsensitiveCompare:@".sgml"]  == NSOrderedSame) {
        
        return @"text/x-sgml";}
    else if ([type caseInsensitiveCompare:@".shar"]  == NSOrderedSame) {
        
        return @"application/x-shar";}
    else if ([type caseInsensitiveCompare:@".shtml"]  == NSOrderedSame) {
        
        return @"magnus-internal/parsed-html";}
    else if ([type caseInsensitiveCompare:@".shw"]  == NSOrderedSame) {
        
        return @"application/presentations";}
    else if ([type caseInsensitiveCompare:@".si6"]  == NSOrderedSame) {
        
        return @"image/si6";}
    else if ([type caseInsensitiveCompare:@".si7"]  == NSOrderedSame) {
        
        return @"image/vnd.stiwap.sis";}
    else if ([type caseInsensitiveCompare:@".si9"]  == NSOrderedSame) {
        
        return @"image/vnd.lgtwap.sis";}
    else if ([type caseInsensitiveCompare:@".sis"]  == NSOrderedSame) {
        
        return @"application/vnd.symbian.install";}
    else if ([type caseInsensitiveCompare:@".sit"]  == NSOrderedSame) {
        
        return @"application/x-stuffit";}
    else if ([type caseInsensitiveCompare:@".skd"]  == NSOrderedSame) {
        
        return @"application/x-koan";}
    else if ([type caseInsensitiveCompare:@".skm"]  == NSOrderedSame) {
        
        return @"application/x-koan";}
    else if ([type caseInsensitiveCompare:@".skp"]  == NSOrderedSame) {
        
        return @"application/x-koan";}
    else if ([type caseInsensitiveCompare:@".skt"]  == NSOrderedSame) {
        
        return @"application/x-koan";}
    else if ([type caseInsensitiveCompare:@".slc"]  == NSOrderedSame) {
        
        return @"application/x-salsa";}
    else if ([type caseInsensitiveCompare:@".smd"]  == NSOrderedSame) {
        
        return @"audio/x-smd";}
    else if ([type caseInsensitiveCompare:@".smi"]  == NSOrderedSame) {
        
        return @"application/smil";}
    else if ([type caseInsensitiveCompare:@".smil"]  == NSOrderedSame) {
        
        return @"application/smil";}
    else if ([type caseInsensitiveCompare:@".smp"]  == NSOrderedSame) {
        
        return @"application/studiom";}
    else if ([type caseInsensitiveCompare:@".smz"]  == NSOrderedSame) {
        
        return @"audio/x-smd";}
    else if ([type caseInsensitiveCompare:@".sh"]  == NSOrderedSame) {
        
        return @"application/x-sh";}
    else if ([type caseInsensitiveCompare:@".snd"]  == NSOrderedSame) {
        
        return @"audio/basic";}
    else if ([type caseInsensitiveCompare:@".spc"]  == NSOrderedSame) {
        
        return @"text/x-speech";}
    else if ([type caseInsensitiveCompare:@".spl"]  == NSOrderedSame) {
        
        return @"application/futuresplash";}
    else if ([type caseInsensitiveCompare:@".spr"]  == NSOrderedSame) {
        
        return @"application/x-sprite";}
    else if ([type caseInsensitiveCompare:@".sprite"]  == NSOrderedSame) {
        
        return @"application/x-sprite";}
    else if ([type caseInsensitiveCompare:@".sdp"]  == NSOrderedSame) {
        
        return @"application/sdp";}
    else if ([type caseInsensitiveCompare:@".spt"]  == NSOrderedSame) {
        
        return @"application/x-spt";}
    else if ([type caseInsensitiveCompare:@".src"]  == NSOrderedSame) {
        
        return @"application/x-wais-source";}
    else if ([type caseInsensitiveCompare:@".stk"]  == NSOrderedSame) {
        
        return @"application/hyperstudio";}
    else if ([type caseInsensitiveCompare:@".stm"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".sv4cpio"]  == NSOrderedSame) {
        
        return @"application/x-sv4cpio";}
    else if ([type caseInsensitiveCompare:@".sv4crc"]  == NSOrderedSame) {
        
        return @"application/x-sv4crc";}
    else if ([type caseInsensitiveCompare:@".svf"]  == NSOrderedSame) {
        
        return @"image/vnd";}
    else if ([type caseInsensitiveCompare:@".svg"]  == NSOrderedSame) {
        
        return @"image/svg-xml";}
    else if ([type caseInsensitiveCompare:@".svh"]  == NSOrderedSame) {
        
        return @"image/svh";}
    else if ([type caseInsensitiveCompare:@".svr"]  == NSOrderedSame) {
        
        return @"x-world/x-svr";}
    else if ([type caseInsensitiveCompare:@".swf"]  == NSOrderedSame) {
        
        return @"application/x-shockwave-flash";}
    else if ([type caseInsensitiveCompare:@".swfl"]  == NSOrderedSame) {
        
        return @"application/x-shockwave-flash";}
    else if ([type caseInsensitiveCompare:@".t"]  == NSOrderedSame) {
        
        return @"application/x-troff";}
    else if ([type caseInsensitiveCompare:@".tad"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".talk"]  == NSOrderedSame) {
        
        return @"text/x-speech";}
    else if ([type caseInsensitiveCompare:@".tar"]  == NSOrderedSame) {
        
        return @"application/x-tar";}
    else if ([type caseInsensitiveCompare:@".taz"]  == NSOrderedSame) {
        
        return @"application/x-tar";}
    else if ([type caseInsensitiveCompare:@".tbp"]  == NSOrderedSame) {
        
        return @"application/x-timbuktu";}
    else if ([type caseInsensitiveCompare:@".tbt"]  == NSOrderedSame) {
        
        return @"application/x-timbuktu";}
    else if ([type caseInsensitiveCompare:@".tcl"]  == NSOrderedSame) {
        
        return @"application/x-tcl";}
    else if ([type caseInsensitiveCompare:@".tex"]  == NSOrderedSame) {
        
        return @"application/x-tex";}
    else if ([type caseInsensitiveCompare:@".texi"]  == NSOrderedSame) {
        
        return @"application/x-texinfo";}
    else if ([type caseInsensitiveCompare:@".texinfo"]  == NSOrderedSame) {
        
        return @"application/x-texinfo";}
    else if ([type caseInsensitiveCompare:@".tgz"]  == NSOrderedSame) {
        
        return @"application/x-tar";}
    else if ([type caseInsensitiveCompare:@".thm"]  == NSOrderedSame) {
        
        return @"application/vnd.eri.thm";}
    else if ([type caseInsensitiveCompare:@".tif"]  == NSOrderedSame) {
        
        return @"image/tiff";}
    else if ([type caseInsensitiveCompare:@".tiff"]  == NSOrderedSame) {
        
        return @"image/tiff";}
    else if ([type caseInsensitiveCompare:@".tki"]  == NSOrderedSame) {
        
        return @"application/x-tkined";}
    else if ([type caseInsensitiveCompare:@".tkined"]  == NSOrderedSame) {
        
        return @"application/x-tkined";}
    else if ([type caseInsensitiveCompare:@".toc"]  == NSOrderedSame) {
        
        return @"application/toc";}
    else if ([type caseInsensitiveCompare:@".toy"]  == NSOrderedSame) {
        
        return @"image/toy";}
    else if ([type caseInsensitiveCompare:@".tr"]  == NSOrderedSame) {
        
        return @"application/x-troff";}
    else if ([type caseInsensitiveCompare:@".trk"]  == NSOrderedSame) {
        
        return @"x-lml/x-gps";}
    else if ([type caseInsensitiveCompare:@".trm"]  == NSOrderedSame) {
        
        return @"application/x-msterminal";}
    else if ([type caseInsensitiveCompare:@".tsi"]  == NSOrderedSame) {
        
        return @"audio/tsplayer";}
    else if ([type caseInsensitiveCompare:@".tsp"]  == NSOrderedSame) {
        
        return @"application/dsptype";}
    else if ([type caseInsensitiveCompare:@".tsv"]  == NSOrderedSame) {
        
        return @"text/tab-separated-values";}
    else if ([type caseInsensitiveCompare:@".ttf"]  == NSOrderedSame) {
        
        return @"application/octet-stream";}
    else if ([type caseInsensitiveCompare:@".ttz"]  == NSOrderedSame) {
        
        return @"application/t-time";}
    else if ([type caseInsensitiveCompare:@".txt"]  == NSOrderedSame) {
        
        return @"text/plain";}
    else if ([type caseInsensitiveCompare:@".ult"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".ustar"]  == NSOrderedSame) {
        
        return @"application/x-ustar";}
    else if ([type caseInsensitiveCompare:@".uu"]  == NSOrderedSame) {
        
        return @"application/x-uuencode";}
    else if ([type caseInsensitiveCompare:@".uue"]  == NSOrderedSame) {
        
        return @"application/x-uuencode";}
    else if ([type caseInsensitiveCompare:@".vcd"]  == NSOrderedSame) {
        
        return @"application/x-cdlink";}
    else if ([type caseInsensitiveCompare:@".vcf"]  == NSOrderedSame) {
        
        return @"text/x-vcard";}
    else if ([type caseInsensitiveCompare:@".vdo"]  == NSOrderedSame) {
        
        return @"video/vdo";}
    else if ([type caseInsensitiveCompare:@".vib"]  == NSOrderedSame) {
        
        return @"audio/vib";}
    else if ([type caseInsensitiveCompare:@".viv"]  == NSOrderedSame) {
        
        return @"video/vivo";}
    else if ([type caseInsensitiveCompare:@".vivo"]  == NSOrderedSame) {
        
        return @"video/vivo";}
    else if ([type caseInsensitiveCompare:@".vmd"]  == NSOrderedSame) {
        
        return @"application/vocaltec-media-desc";}
    else if ([type caseInsensitiveCompare:@".vmf"]  == NSOrderedSame) {
        
        return @"application/vocaltec-media-file";}
    else if ([type caseInsensitiveCompare:@".vmi"]  == NSOrderedSame) {
        
        return @"application/x-dreamcast-vms-info";}
    else if ([type caseInsensitiveCompare:@".vms"]  == NSOrderedSame) {
        
        return @"application/x-dreamcast-vms";}
    else if ([type caseInsensitiveCompare:@".vox"]  == NSOrderedSame) {
        
        return @"audio/voxware";}
    else if ([type caseInsensitiveCompare:@".vqe"]  == NSOrderedSame) {
        
        return @"audio/x-twinvq-plugin";}
    else if ([type caseInsensitiveCompare:@".vqf"]  == NSOrderedSame) {
        
        return @"audio/x-twinvq";}
    else if ([type caseInsensitiveCompare:@".vql"]  == NSOrderedSame) {
        
        return @"audio/x-twinvq";}
    else if ([type caseInsensitiveCompare:@".vre"]  == NSOrderedSame) {
        
        return @"x-world/x-vream";}
    else if ([type caseInsensitiveCompare:@".vrml"]  == NSOrderedSame) {
        
        return @"x-world/x-vrml";}
    else if ([type caseInsensitiveCompare:@".vrt"]  == NSOrderedSame) {
        
        return @"x-world/x-vrt";}
    else if ([type caseInsensitiveCompare:@".vrw"]  == NSOrderedSame) {
        
        return @"x-world/x-vream";}
    else if ([type caseInsensitiveCompare:@".vts"]  == NSOrderedSame) {
        
        return @"workbook/formulaone";}
    else if ([type caseInsensitiveCompare:@".wax"]  == NSOrderedSame) {
        
        return @"audio/x-ms-wax";}
    else if ([type caseInsensitiveCompare:@".wbmp"]  == NSOrderedSame) {
        
        return @"image/vnd.wap.wbmp";}
    else if ([type caseInsensitiveCompare:@".web"]  == NSOrderedSame) {
        
        return @"application/vnd.xara";}
    else if ([type caseInsensitiveCompare:@".wav"]  == NSOrderedSame) {
        
        return @"audio/x-wav";}
    else if ([type caseInsensitiveCompare:@".wma"]  == NSOrderedSame) {
        
        return @"audio/x-ms-wma";}
    else if ([type caseInsensitiveCompare:@".wmv"]  == NSOrderedSame) {
        
        return @"audio/x-ms-wmv";}
    else if ([type caseInsensitiveCompare:@".wi"]  == NSOrderedSame) {
        
        return @"image/wavelet";}
    else if ([type caseInsensitiveCompare:@".wis"]  == NSOrderedSame) {
        
        return @"application/x-InstallShield";}
    else if ([type caseInsensitiveCompare:@".wm"]  == NSOrderedSame) {
        
        return @"video/x-ms-wm";}
    else if ([type caseInsensitiveCompare:@".wmd"]  == NSOrderedSame) {
        
        return @"application/x-ms-wmd";}
    else if ([type caseInsensitiveCompare:@".wmf"]  == NSOrderedSame) {
        
        return @"application/x-msmetafile";}
    else if ([type caseInsensitiveCompare:@".wml"]  == NSOrderedSame) {
        
        return @"text/vnd.wap.wml";}
    else if ([type caseInsensitiveCompare:@".wmlc"]  == NSOrderedSame) {
        
        return @"application/vnd.wap.wmlc";}
    else if ([type caseInsensitiveCompare:@".wmls"]  == NSOrderedSame) {
        
        return @"text/vnd.wap.wmlscript";}
    else if ([type caseInsensitiveCompare:@".wmlsc"]  == NSOrderedSame) {
        
        return @"application/vnd.wap.wmlscriptc";}
    else if ([type caseInsensitiveCompare:@".wmlscript"]  == NSOrderedSame) {
        
        return @"text/vnd.wap.wmlscript";}
    else if ([type caseInsensitiveCompare:@".wmv"]  == NSOrderedSame) {
        
        return @"video/x-ms-wmv";}
    else if ([type caseInsensitiveCompare:@".wmx"]  == NSOrderedSame) {
        
        return @"video/x-ms-wmx";}
    else if ([type caseInsensitiveCompare:@".wmz"]  == NSOrderedSame) {
        
        return @"application/x-ms-wmz";}
    else if ([type caseInsensitiveCompare:@".wpng"]  == NSOrderedSame) {
        
        return @"image/x-up-wpng";}
    else if ([type caseInsensitiveCompare:@".wps"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-works";}
    else if ([type caseInsensitiveCompare:@".wpt"]  == NSOrderedSame) {
        
        return @"x-lml/x-gps";}
    else if ([type caseInsensitiveCompare:@".wri"]  == NSOrderedSame) {
        
        return @"application/x-mswrite";}
    else if ([type caseInsensitiveCompare:@".wrl"]  == NSOrderedSame) {
        
        return @"x-world/x-vrml";}
    else if ([type caseInsensitiveCompare:@".wrz"]  == NSOrderedSame) {
        
        return @"x-world/x-vrml";}
    else if ([type caseInsensitiveCompare:@".ws"]  == NSOrderedSame) {
        
        return @"text/vnd.wap.wmlscript";}
    else if ([type caseInsensitiveCompare:@".wsc"]  == NSOrderedSame) {
        
        return @"application/vnd.wap.wmlscriptc";}
    else if ([type caseInsensitiveCompare:@".wv"]  == NSOrderedSame) {
        
        return @"video/wavelet";}
    else if ([type caseInsensitiveCompare:@".wvx"]  == NSOrderedSame) {
        
        return @"video/x-ms-wvx";}
    else if ([type caseInsensitiveCompare:@".wxl"]  == NSOrderedSame) {
        
        return @"application/x-wxl";}
    else if ([type caseInsensitiveCompare:@".x-gzip"]  == NSOrderedSame) {
        
        return @"application/x-gzip";}
    else if ([type caseInsensitiveCompare:@".xar"]  == NSOrderedSame) {
        
        return @"application/vnd.xara";}
    else if ([type caseInsensitiveCompare:@".xbm"]  == NSOrderedSame) {
        
        return @"image/x-xbitmap";}
    else if ([type caseInsensitiveCompare:@".xdm"]  == NSOrderedSame) {
        
        return @"application/x-xdma";}
    else if ([type caseInsensitiveCompare:@".xdma"]  == NSOrderedSame) {
        
        return @"application/x-xdma";}
    else if ([type caseInsensitiveCompare:@".xdw"]  == NSOrderedSame) {
        
        return @"application/vnd.fujixerox.docuworks";}
    else if ([type caseInsensitiveCompare:@".xht"]  == NSOrderedSame) {
        
        return @"application/xhtml+xml";}
    else if ([type caseInsensitiveCompare:@".xhtm"]  == NSOrderedSame) {
        
        return @"application/xhtml+xml";}
    else if ([type caseInsensitiveCompare:@".xhtml"]  == NSOrderedSame) {
        
        return @"application/xhtml+xml";}
    else if ([type caseInsensitiveCompare:@".xla"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xlc"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xll"]  == NSOrderedSame) {
        
        return @"application/x-excel";}
    else if ([type caseInsensitiveCompare:@".xlm"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xls"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xlsx"]  == NSOrderedSame) {
        
        return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";}
    else if ([type caseInsensitiveCompare:@".xlt"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xlw"]  == NSOrderedSame) {
        
        return @"application/vnd.ms-excel";}
    else if ([type caseInsensitiveCompare:@".xm"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".xml"]  == NSOrderedSame) {
        
        return @"text/xml";}
    else if ([type caseInsensitiveCompare:@".xmz"]  == NSOrderedSame) {
        
        return @"audio/x-mod";}
    else if ([type caseInsensitiveCompare:@".xpi"]  == NSOrderedSame) {
        
        return @"application/x-xpinstall";}
    else if ([type caseInsensitiveCompare:@".xpm"]  == NSOrderedSame) {
        
        return @"image/x-xpixmap";}
    else if ([type caseInsensitiveCompare:@".xsit"]  == NSOrderedSame) {
        
        return @"text/xml";}
    else if ([type caseInsensitiveCompare:@".xsl"]  == NSOrderedSame) {
        
        return @"text/xml";}
    else if ([type caseInsensitiveCompare:@".xul"]  == NSOrderedSame) {
        
        return @"text/xul";}
    else if ([type caseInsensitiveCompare:@".xwd"]  == NSOrderedSame) {
        
        return @"image/x-xwindowdump";}
    else if ([type caseInsensitiveCompare:@".xyz"]  == NSOrderedSame) {
        
        return @"chemical/x-pdb";}
    else if ([type caseInsensitiveCompare:@".yz1"]  == NSOrderedSame) {
        
        return @"application/x-yz1";}
    else if ([type caseInsensitiveCompare:@".z"]  == NSOrderedSame) {
        
        return @"application/x-compress";}
    else if ([type caseInsensitiveCompare:@".zac"]  == NSOrderedSame) {
        
        return @"application/x-zaurus-zac";}
    else if ([type caseInsensitiveCompare:@".zip"]  == NSOrderedSame) {
        
        return @"application/zip";}
    else if ([type caseInsensitiveCompare:@""]  == NSOrderedSame) {
        
        return @"*/*";}
    else return nil;
    
}

@end
