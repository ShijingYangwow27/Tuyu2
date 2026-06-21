import Foundation

/// 56 款模板的本地 mock 数据（用于开发、演示、单元测试）
public enum TemplateData {

    public static let categories: [Category] = [
        Category(id: "recommend", name: "推荐", icon: "sparkles", order: 0, count: nil),
        Category(id: "portrait", name: "人像", icon: "person.crop.circle", order: 1, count: 18),
        Category(id: "product", name: "商品", icon: "bag", order: 2, count: 12),
        Category(id: "scene", name: "风景", icon: "mountain.2", order: 3, count: 8),
        Category(id: "festival", name: "节日", icon: "gift", order: 4, count: 8),
        Category(id: "id", name: "证件", icon: "person.text.rectangle", order: 5, count: 4),
        Category(id: "repair", name: "修复", icon: "wand.and.stars", order: 6, count: 6)
    ]

    public static let templates: [Template] = portrait + product + scene + festival + id + repair

    // MARK: - 人像 18 款
    public static let portrait: [Template] = [
        Template(id: "P-01", name: "韩系证件棚", category: categories[1], difficulty: .easy, cover: "p01", description: "韩系清新风格证件照，适合简历、考研、护照", effect: "浅米色/淡蓝渐变背景，韩系清透风格", operators: ["matting", "bg_swap", "style_transfer", "face_alignment"], prompt: "Korean idol style", estimatedTime: 8, tags: ["证件照", "韩系", "热门"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "P-02", name: "杂志硬光大片", category: categories[1], difficulty: .medium, cover: "p02", description: "强对比硬光影，杂志封面级效果", effect: "高对比光影，质感肌肤", operators: ["matting", "lighting", "style_transfer"], prompt: "Magazine cover, hard light", estimatedTime: 10, tags: ["杂志", "高级感"], isHot: false, launchPriority: .cold_30, order: 2),
        Template(id: "P-03", name: "居家暖光写真", category: categories[1], difficulty: .medium, cover: "p03", description: "暖色调居家氛围，温馨自然", effect: "暖色调，居家氛围感", operators: ["matting", "lighting", "style_transfer"], prompt: "Home warm light", estimatedTime: 10, tags: ["居家", "暖光"], isHot: true, launchPriority: .cold_30, order: 3),
        Template(id: "P-04", name: "复古港风棚", category: categories[1], difficulty: .medium, cover: "p04", description: "90 年代港风怀旧色调", effect: "复古胶片质感", operators: ["matting", "style_transfer", "filter"], prompt: "Retro Hong Kong", estimatedTime: 9, tags: ["复古", "港风"], isHot: true, launchPriority: .cold_30, order: 4),
        Template(id: "P-05", name: "极简白底职业照", category: categories[1], difficulty: .easy, cover: "p05", description: "纯色背景极简职业照", effect: "白底干净，专业感", operators: ["matting", "bg_swap"], prompt: "Professional headshot", estimatedTime: 5, tags: ["职业照"], isHot: false, launchPriority: .cold_30, order: 5),
        Template(id: "P-06", name: "杂志封面", category: categories[1], difficulty: .hard, cover: "p06", description: "杂志封面级排版与效果", effect: "杂志封面+文字", operators: ["matting", "style_transfer", "typography"], prompt: "Magazine cover layout", estimatedTime: 12, tags: ["杂志", "封面"], isHot: true, launchPriority: .cold_30, order: 6),
        Template(id: "P-07", name: "公园森系清新", category: categories[1], difficulty: .medium, cover: "p07", description: "自然森系氛围", effect: "绿色森系", operators: ["matting", "bg_swap", "filter"], prompt: "Forest fresh", estimatedTime: 9, tags: ["森系", "清新"], isHot: false, launchPriority: .cold_30, order: 7),
        Template(id: "P-08", name: "城市街拍潮酷", category: categories[1], difficulty: .medium, cover: "p08", description: "街拍感潮酷风格", effect: "街拍背景", operators: ["matting", "style_transfer"], prompt: "Street style", estimatedTime: 9, tags: ["街拍", "潮酷"], isHot: true, launchPriority: .cold_30, order: 8),
        Template(id: "P-09", name: "银杏金秋", category: categories[1], difficulty: .medium, cover: "p09", description: "秋季金黄银杏氛围", effect: "秋季色调", operators: ["matting", "bg_swap", "filter"], prompt: "Autumn ginkgo", estimatedTime: 9, tags: ["秋季", "银杏"], isHot: false, launchPriority: .cold_30, order: 9),
        Template(id: "P-10", name: "樱花春日", category: categories[1], difficulty: .medium, cover: "p10", description: "春季粉色樱花氛围", effect: "春季色调", operators: ["matting", "bg_swap", "filter"], prompt: "Spring cherry blossom", estimatedTime: 9, tags: ["春季", "樱花"], isHot: true, launchPriority: .cold_30, order: 10),
        Template(id: "P-11", name: "雪山公路", category: categories[1], difficulty: .hard, cover: "p11", description: "雪山背景高级感", effect: "雪山壮阔", operators: ["matting", "bg_swap", "style_transfer"], prompt: "Snow mountain", estimatedTime: 11, tags: ["雪山", "高级感"], isHot: true, launchPriority: .cold_30, order: 11),
        Template(id: "P-12", name: "二次元漫画头像", category: categories[1], difficulty: .hard, cover: "p12", description: "二次元漫画风格头像", effect: "动漫风格", operators: ["face_detect", "style_transfer"], prompt: "Anime style", estimatedTime: 12, tags: ["二次元", "动漫"], isHot: true, launchPriority: .cold_30, order: 12),
        Template(id: "P-13", name: "迪士尼公主风", category: categories[1], difficulty: .hard, cover: "p13", description: "迪士尼公主风格", effect: "迪士尼动画", operators: ["face_detect", "style_transfer"], prompt: "Disney princess", estimatedTime: 12, tags: ["迪士尼", "公主"], isHot: true, launchPriority: .cold_30, order: 13),
        Template(id: "P-14", name: "赛博朋克", category: categories[1], difficulty: .medium, cover: "p14", description: "赛博朋克霓虹风格", effect: "霓虹赛博", operators: ["face_detect", "style_transfer"], prompt: "Cyberpunk neon", estimatedTime: 10, tags: ["赛博朋克"], isHot: false, launchPriority: .cold_30, order: 14),
        Template(id: "P-15", name: "国风水墨", category: categories[1], difficulty: .medium, cover: "p15", description: "国风水墨画风格", effect: "水墨画", operators: ["face_detect", "style_transfer"], prompt: "Chinese ink", estimatedTime: 10, tags: ["国风", "水墨"], isHot: true, launchPriority: .cold_30, order: 15),
        Template(id: "P-16", name: "小红书爆款九宫格", category: categories[1], difficulty: .medium, cover: "p16", description: "九宫格拼图", effect: "9 张拼图", operators: ["multi_face", "bg_swap", "collage"], prompt: "9-grid collage", estimatedTime: 15, tags: ["九宫格", "小红书"], isHot: true, launchPriority: .cold_30, order: 16),
        Template(id: "P-17", name: "朋友圈 INS 风", category: categories[1], difficulty: .easy, cover: "p17", description: "INS 风暗角滤镜", effect: "INS 暗角", operators: ["filter", "vignette"], prompt: "Instagram style", estimatedTime: 4, tags: ["INS"], isHot: false, launchPriority: .extended_26, order: 17),
        Template(id: "P-18", name: "闺蜜合照 P 图位", category: categories[1], difficulty: .hard, cover: "p18", description: "闺蜜合照修图", effect: "多人美颜", operators: ["multi_face", "style_transfer"], prompt: "Group photo", estimatedTime: 14, tags: ["合照"], isHot: true, launchPriority: .extended_26, order: 18)
    ]

    // MARK: - 商品 12 款
    public static let product: [Template] = [
        Template(id: "PR-01", name: "平铺白底主图", category: categories[2], difficulty: .easy, cover: "pr01", description: "电商主图平铺白底", effect: "纯白背景", operators: ["matting", "bg_swap", "lighting"], prompt: "Product, white bg", estimatedTime: 5, tags: ["电商", "白底"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "PR-02", name: "AI 模特试衣", category: categories[2], difficulty: .hard, cover: "pr02", description: "AI 模特试穿服装", effect: "虚拟试衣", operators: ["matting", "virtual_tryon"], prompt: "Virtual tryon", estimatedTime: 20, tags: ["试衣", "AI"], isHot: true, launchPriority: .extended_26, order: 2),
        Template(id: "PR-03", name: "街拍场景图", category: categories[2], difficulty: .hard, cover: "pr03", description: "街拍感场景", effect: "街拍背景", operators: ["matting", "bg_swap", "style"], prompt: "Street scene", estimatedTime: 12, tags: ["街拍"], isHot: false, launchPriority: .extended_26, order: 3),
        Template(id: "PR-04", name: "居家生活场景", category: categories[2], difficulty: .medium, cover: "pr04", description: "居家生活场景", effect: "居家背景", operators: ["matting", "bg_swap", "filter"], prompt: "Home scene", estimatedTime: 9, tags: ["居家"], isHot: false, launchPriority: .cold_30, order: 4),
        Template(id: "PR-05", name: "精致美妆单品图", category: categories[2], difficulty: .medium, cover: "pr05", description: "美妆单品精修", effect: "美妆精修", operators: ["matting", "lighting", "style"], prompt: "Beauty product", estimatedTime: 9, tags: ["美妆"], isHot: true, launchPriority: .cold_30, order: 5),
        Template(id: "PR-06", name: "精致妆效照", category: categories[2], difficulty: .medium, cover: "pr06", description: "精致妆面增强", effect: "妆面增强", operators: ["face_detect", "style", "filter"], prompt: "Makeup effect", estimatedTime: 10, tags: ["妆效"], isHot: true, launchPriority: .cold_30, order: 6),
        Template(id: "PR-07", name: "口红颜色试色", category: categories[2], difficulty: .easy, cover: "pr07", description: "口红试色", effect: "口红颜色", operators: ["face_detect", "color_transfer"], prompt: "Lipstick color", estimatedTime: 4, tags: ["口红", "美妆"], isHot: true, launchPriority: .cold_30, order: 7),
        Template(id: "PR-08", name: "家居场景图", category: categories[2], difficulty: .medium, cover: "pr08", description: "家居品场景", effect: "家居场景", operators: ["matting", "bg_swap"], prompt: "Home decor", estimatedTime: 9, tags: ["家居"], isHot: false, launchPriority: .extended_26, order: 8),
        Template(id: "PR-09", name: "简约白底图", category: categories[2], difficulty: .easy, cover: "pr09", description: "简约白底", effect: "白底", operators: ["matting", "bg_swap"], prompt: "Simple white bg", estimatedTime: 5, tags: ["简约"], isHot: false, launchPriority: .cold_30, order: 9),
        Template(id: "PR-10", name: "食欲感主图", category: categories[2], difficulty: .medium, cover: "pr10", description: "食品食欲感", effect: "食欲感", operators: ["matting", "lighting", "style"], prompt: "Appetizing", estimatedTime: 10, tags: ["食品"], isHot: true, launchPriority: .extended_26, order: 10),
        Template(id: "PR-11", name: "科技感主图", category: categories[2], difficulty: .medium, cover: "pr11", description: "3C 科技感", effect: "科技感", operators: ["matting", "style_transfer"], prompt: "Tech style", estimatedTime: 9, tags: ["科技"], isHot: false, launchPriority: .extended_26, order: 11),
        Template(id: "PR-12", name: "简约白底主图", category: categories[2], difficulty: .easy, cover: "pr12", description: "白底主图", effect: "白底", operators: ["matting", "bg_swap"], prompt: "White bg", estimatedTime: 5, tags: ["白底"], isHot: false, launchPriority: .cold_30, order: 12)
    ]

    // MARK: - 风景 8 款
    public static let scene: [Template] = [
        Template(id: "S-01", name: "天空晚霞", category: categories[3], difficulty: .easy, cover: "s01", description: "天空晚霞效果", effect: "晚霞天空", operators: ["sky_swap", "style"], prompt: "Sunset sky", estimatedTime: 5, tags: ["晚霞"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "S-02", name: "阴天变晴天", category: categories[3], difficulty: .easy, cover: "s02", description: "阴天变晴", effect: "晴空", operators: ["sky_swap", "lighting"], prompt: "Sunny sky", estimatedTime: 5, tags: ["晴天"], isHot: true, launchPriority: .cold_30, order: 2),
        Template(id: "S-03", name: "城市夜景霓虹", category: categories[3], difficulty: .hard, cover: "s03", description: "城市夜景", effect: "霓虹夜景", operators: ["sky_swap", "lighting", "style"], prompt: "City night", estimatedTime: 12, tags: ["夜景"], isHot: true, launchPriority: .extended_26, order: 3),
        Template(id: "S-04", name: "绿植高级感", category: categories[3], difficulty: .easy, cover: "s04", description: "绿植高级感", effect: "绿植增强", operators: ["enhance", "style"], prompt: "Green enhance", estimatedTime: 5, tags: ["绿植"], isHot: false, launchPriority: .cold_30, order: 4),
        Template(id: "S-05", name: "古镇烟雨江南", category: categories[3], difficulty: .medium, cover: "s05", description: "古镇烟雨", effect: "水墨古镇", operators: ["style_transfer", "filter"], prompt: "Ancient town", estimatedTime: 9, tags: ["古镇"], isHot: true, launchPriority: .extended_26, order: 5),
        Template(id: "S-06", name: "沙滩度假风", category: categories[3], difficulty: .easy, cover: "s06", description: "沙滩度假", effect: "沙滩", operators: ["sky_swap", "filter"], prompt: "Beach", estimatedTime: 5, tags: ["沙滩"], isHot: false, launchPriority: .cold_30, order: 6),
        Template(id: "S-07", name: "樱花季", category: categories[3], difficulty: .easy, cover: "s07", description: "樱花季", effect: "樱花", operators: ["bg_swap", "style"], prompt: "Cherry blossom", estimatedTime: 5, tags: ["樱花"], isHot: true, launchPriority: .extended_26, order: 7),
        Template(id: "S-08", name: "银杏林", category: categories[3], difficulty: .easy, cover: "s08", description: "银杏林", effect: "银杏", operators: ["bg_swap", "style"], prompt: "Ginkgo forest", estimatedTime: 5, tags: ["银杏"], isHot: false, launchPriority: .extended_26, order: 8)
    ]

    // MARK: - 节日 8 款
    public static let festival: [Template] = [
        Template(id: "F-01", name: "新春喜庆", category: categories[4], difficulty: .easy, cover: "f01", description: "新春喜庆氛围", effect: "红灯笼烟花", operators: ["filter", "overlay"], prompt: "Chinese New Year", estimatedTime: 4, tags: ["春节"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "F-02", name: "浪漫七夕", category: categories[4], difficulty: .easy, cover: "f02", description: "七夕浪漫", effect: "爱心元素", operators: ["filter", "overlay"], prompt: "Qixi", estimatedTime: 4, tags: ["七夕"], isHot: true, launchPriority: .cold_30, order: 2),
        Template(id: "F-03", name: "中秋团圆", category: categories[4], difficulty: .easy, cover: "f03", description: "中秋团圆", effect: "月亮元素", operators: ["filter", "overlay"], prompt: "Mid-autumn", estimatedTime: 4, tags: ["中秋"], isHot: true, launchPriority: .cold_30, order: 3),
        Template(id: "F-04", name: "圣诞狂欢", category: categories[4], difficulty: .easy, cover: "f04", description: "圣诞氛围", effect: "圣诞树", operators: ["filter", "overlay"], prompt: "Christmas", estimatedTime: 4, tags: ["圣诞"], isHot: true, launchPriority: .cold_30, order: 4),
        Template(id: "F-05", name: "万圣节", category: categories[4], difficulty: .easy, cover: "f05", description: "万圣节氛围", effect: "南瓜幽灵", operators: ["filter", "overlay"], prompt: "Halloween", estimatedTime: 4, tags: ["万圣"], isHot: false, launchPriority: .extended_26, order: 5),
        Template(id: "F-06", name: "感恩节", category: categories[4], difficulty: .easy, cover: "f06", description: "感恩节氛围", effect: "火鸡南瓜", operators: ["filter", "overlay"], prompt: "Thanksgiving", estimatedTime: 4, tags: ["感恩"], isHot: false, launchPriority: .extended_26, order: 6),
        Template(id: "F-07", name: "生日祝福", category: categories[4], difficulty: .easy, cover: "f07", description: "生日氛围", effect: "蛋糕蜡烛", operators: ["filter", "overlay"], prompt: "Birthday", estimatedTime: 4, tags: ["生日"], isHot: true, launchPriority: .cold_30, order: 7),
        Template(id: "F-08", name: "毕业季", category: categories[4], difficulty: .easy, cover: "f08", description: "毕业季氛围", effect: "学士帽", operators: ["filter", "overlay"], prompt: "Graduation", estimatedTime: 4, tags: ["毕业"], isHot: true, launchPriority: .cold_30, order: 8)
    ]

    // MARK: - 证件 4 款
    public static let id: [Template] = [
        Template(id: "ID-01", name: "蓝底证件照", category: categories[5], difficulty: .easy, cover: "id01", description: "标准蓝底", effect: "蓝底", operators: ["matting", "bg_swap", "face_alignment"], prompt: "Blue bg ID", estimatedTime: 5, tags: ["蓝底"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "ID-02", name: "白底证件照", category: categories[5], difficulty: .easy, cover: "id02", description: "标准白底", effect: "白底", operators: ["matting", "bg_swap", "face_alignment"], prompt: "White bg ID", estimatedTime: 5, tags: ["白底"], isHot: true, launchPriority: .cold_30, order: 2),
        Template(id: "ID-03", name: "红底证件照", category: categories[5], difficulty: .easy, cover: "id03", description: "标准红底", effect: "红底", operators: ["matting", "bg_swap", "face_alignment"], prompt: "Red bg ID", estimatedTime: 5, tags: ["红底"], isHot: true, launchPriority: .cold_30, order: 3),
        Template(id: "ID-04", name: "签证照片", category: categories[5], difficulty: .easy, cover: "id04", description: "签证照片", effect: "多尺寸", operators: ["matting", "bg_swap", "face_alignment", "size_match"], prompt: "Visa photo", estimatedTime: 5, tags: ["签证"], isHot: true, launchPriority: .cold_30, order: 4)
    ]

    // MARK: - 修复 6 款
    public static let repair: [Template] = [
        Template(id: "R-01", name: "老照片修复", category: categories[6], difficulty: .hard, cover: "r01", description: "老照片清晰度+色彩修复", effect: "老照片修复", operators: ["face_detect", "denoise", "super_resolution", "face_enhance", "colorize"], prompt: "Old photo restore", estimatedTime: 10, tags: ["修复", "老照片"], isHot: true, launchPriority: .cold_30, order: 1),
        Template(id: "R-02", name: "黑白照片上色", category: categories[6], difficulty: .hard, cover: "r02", description: "黑白变彩色", effect: "智能上色", operators: ["colorize"], prompt: "Colorize", estimatedTime: 8, tags: ["上色"], isHot: true, launchPriority: .cold_30, order: 2),
        Template(id: "R-03", name: "模糊变清晰", category: categories[6], difficulty: .medium, cover: "r03", description: "模糊照片清晰化", effect: "超分辨率", operators: ["super_resolution", "denoise"], prompt: "Super resolution", estimatedTime: 8, tags: ["超分"], isHot: true, launchPriority: .cold_30, order: 3),
        Template(id: "R-04", name: "照片去皱", category: categories[6], difficulty: .medium, cover: "r04", description: "照片去除褶皱", effect: "局部修复", operators: ["inpaint", "face_enhance"], prompt: "De-wrinkle", estimatedTime: 9, tags: ["修复"], isHot: false, launchPriority: .extended_26, order: 4),
        Template(id: "R-05", name: "照片去水印", category: categories[6], difficulty: .easy, cover: "r05", description: "去除自己照片水印", effect: "局部重绘", operators: ["inpaint"], prompt: "Remove watermark", estimatedTime: 6, tags: ["去水印"], isHot: false, launchPriority: .extended_26, order: 5),
        Template(id: "R-06", name: "人像美颜磨皮", category: categories[6], difficulty: .easy, cover: "r06", description: "人像美颜", effect: "美颜磨皮", operators: ["face_enhance", "skin_retouch"], prompt: "Beauty", estimatedTime: 5, tags: ["美颜"], isHot: true, launchPriority: .cold_30, order: 6)
    ]

    public static func templates(category: String?) -> [Template] {
        guard let category = category, category != "recommend" else {
            return templates
        }
        return templates.filter { $0.category.id == category }
    }

    public static func template(id: String) -> Template? {
        templates.first(where: { $0.id == id })
    }
}
