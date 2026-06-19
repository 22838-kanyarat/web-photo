<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>แผนที่ประเทศไทยและข้อมูลภูมิภาค</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700&display=swap');

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Sarabun', sans-serif;
        }

        body {
            background-color: #f4f7f6;
            color: #2c3e50;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        header {
            text-align: center;
            margin-bottom: 30px;
        }

        header h1 {
            font-size: 2.5rem;
            color: #1a365d;
            margin-bottom: 10px;
        }

        header p {
            color: #718096;
            font-size: 1.1rem;
        }

        /* ส่วนจัดวางหน้าจอหลัก */
        .main-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            width: 100%;
            max-width: 1200px;
            background: #ffffff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        /* ส่วนซ้าย: แผนที่ SVG */
        .map-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #f7fafc;
            border-radius: 15px;
            padding: 20px;
            border: 1px solid #e2e8f0;
        }

        /* ตกแต่งกราฟิกรูปแผนที่จำลองด้วยรูปทรง SVG */
        .thailand-svg {
            width: 100%;
            max-width: 400px;
            height: auto;
        }

        /* กำหนดสไตล์เมื่อเอาเมาส์ไปชี้ที่แต่ละภาค */
        .region-block {
            cursor: pointer;
            transition: all 0.3s ease;
            stroke: #ffffff;
            stroke-width: 3;
        }

        .region-block:hover {
            fill-opacity: 0.8;
            filter: drop-shadow(0px 5px 5px rgba(0,0,0,0.15));
        }

        /* สีประจำแต่ละภาค (สถานะปกติ) */
        #north { fill: #4299e1; }     /* เหนือ - ฟ้า */
        #northeast { fill: #ed8936; } /* อีสาน - ส้ม */
        #central { fill: #48bb78; }   /* กลาง - เขียว */
        #east { fill: #ecc94b; }      /* ตะวันออก - เหลือง */
        #west { fill: #9f7aea; }      /* ตะวันตก - ม่วง */
        #south { fill: #f56565; }     /* ใต้ - แดง */

        /* ส่วนขวา: แสดงข้อมูล */
        .info-section {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .info-card {
            background: #ffffff;
            border: 2px solid #e2e8f0;
            border-radius: 15px;
            padding: 30px;
            min-height: 400px;
            transition: all 0.3s ease;
        }

        .info-card.active-card {
            border-color: #3182ce;
            box-shadow: 0 4px 12px rgba(49, 130, 206, 0.1);
        }

        .info-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2b6cb0;
            margin-bottom: 15px;
            border-bottom: 2px solid #edf2f7;
            padding-bottom: 10px;
        }

        .info-content p {
            font-size: 1.1rem;
            line-height: 1.7;
            color: #4a5568;
            margin-bottom: 15px;
        }

        /* ส่วนพื้นที่สำหรับคุณนำรูปภาพมาใส่เองในอนาคต */
        .image-placeholder {
            width: 100%;
            height: 200px;
            background-color: #edf2f7;
            border: 2px dashed #cbd5e0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a0aec0;
            font-weight: 500;
            margin-top: 20px;
            overflow: hidden;
        }

        .image-placeholder img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* รองรับการแสดงผลบนมือถือ */
        @media (max-width: 768px) {
            .main-container {
                grid-template-columns: 1fr;
            }
            header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>แอนิเมชันแผนภาพประเทศไทย</h1>
        <p>คลิกเลือกภูมิภาคบนแผนที่เพื่อดูข้อมูลรายละเอียด</p>
    </header>

    <div class="main-container">
        
        <div class="map-section">
            <svg class="thailand-svg" viewBox="0 0 400 600" xmlns="http://www.w3.org/2000/svg">
                <path id="north" class="region-block" d="M 120 40 L 240 40 L 260 140 L 190 200 L 110 150 Z" onclick="showInfo('north')"/>
                <text x="170" y="100" fill="white" font-weight="bold" pointer-events="none">ภาคเหนือ</text>

                <path id="northeast" class="region-block" d="M 241 145 L 380 140 L 370 300 L 240 280 L 210 200 Z" onclick="showInfo('northeast')"/>
                <text x="270" y="210" fill="white" font-weight="bold" pointer-events="none">ภาคอีสาน</text>

                <path id="central" class="region-block" d="M 160 205 L 235 205 L 235 320 L 170 320 L 150 250 Z" onclick="showInfo('central')"/>
                <text x="175" y="265" fill="white" font-weight="bold" pointer-events="none">ภาคกลาง</text>

                <path id="west" class="region-block" d="M 105 160 L 155 210 L 145 260 L 165 330 L 120 330 L 110 240 Z" onclick="showInfo('west')"/>
                <text x="105" y="280" fill="white" font-weight="bold" pointer-events="none">ภาคตะวันตก</text>

                <path id="east" class="region-block" d="M 238 290 L 300 300 L 280 370 L 220 340 Z" onclick="showInfo('east')"/>
                <text x="235" y="335" fill="white" font-weight="bold" pointer-events="none">ภาคตะวันออก</text>

                <path id="south" class="region-block" d="M 135 335 L 175 335 L 160 450 L 210 520 L 170 580 L 120 440 Z" onclick="showInfo('south')"/>
                <text x="140" y="450" fill="white" font-weight="bold" pointer-events="none">ภาคใต้</text>
            </svg>
        </div>

        <div class="info-section">
            <div id="infoCard" class="info-card">
                <div id="infoTitle" class="info-title">กรุณาเลือกภูมิภาค</div>
                <div id="infoContent" class="info-content">
                    <p>คลิกที่พื้นที่บนแผนที่สีสันต่างๆ ทางซ้ายมือ เพื่อเปิดดูข้อมูลประวัติศาสตร์ วัฒนธรรม หรือสถานที่ท่องเที่ยวที่น่าสนใจประจำภูมิภาคสารสนเทศนั้นๆ</p>
                </div>
                
                <div class="image-placeholder" id="imageContainer">
                    <span>พื้นที่สำหรับใส่รูปภาพของคุณในอนาคต</span>
                    </div>
            </div>
        </div>

    </div>

    <script>
        // ชุดข้อมูลของแต่ละภาค (คุณสามารถแก้ไขข้อความตรงนี้ได้ตามใจชอบเลยครับ)
        const regionData = {
            north: {
                title: "ภาคเหนือ",
                description: "ดินแดนแห่งภูเขาสลับซับซ้อนและวัฒนธรรมล้านนาที่งดงาม มีอากาศหนาวเย็นในฤดูหนาว สถานที่ท่องเที่ยวสำคัญ เช่น ดอยอินทนนท์ วัดพระธาตุดอยสุเทพ จังหวัดเชียงใหม่ และวัดร่องขุ่น จังหวัดเชียงราย",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: ดอยอินทนนท์ หรือวัฒนธรรมล้านนา"
            },
            northeast: {
                title: "ภาคตะวันออกเฉียงเหนือ (อีสาน)",
                description: "ภูมิภาคที่มีพื้นที่กว้างใหญ่ที่สุด อุดมไปด้วยวัฒนธรรมที่เป็นเอกลักษณ์ อาหารรสจัดจ้าน (เช่น ส้มตำ ลาบ) และประเพณีที่สนุกสนาน เช่น ประเพณีแห่เทียนพรรษา บุญบั้งไฟ และมีแหล่งโบราณคดีที่สำคัญอย่างบ้านเชียง",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: อุทยานประวัติศาสตร์พนมรุ้ง หรือ เทศกาลผีตาโขน"
            },
            central: {
                title: "ภาคกลาง",
                description: "อู่ข้าวอู่น้ำของประเทศ พื้นที่ส่วนใหญ่เป็นที่ราบลุ่มแม่น้ำ เหมาะแก่การทำการเกษตร เป็นที่ตั้งของเมืองหลวงอย่างกรุงเทพมหานคร และเมืองประวัติศาสตร์อย่างอุทยานประวัติศาสตร์พระนครศรีอยุธยา",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: วัดพระแก้ว หรือ ทุ่งนาภาคกลาง"
            },
            east: {
                title: "ภาคตะวันออก",
                description: "ภูมิภาคขนาดเล็กแต่ขับเคลื่อนเศรษฐกิจได้สูง มีชื่อเสียงในด้านการท่องเที่ยวทางทะเล เช่น พัทยา เกาะเสม็ด เกาะช้าง และยังเป็นแหล่งปลูกผลไม้เมืองร้อนที่สำคัญของประเทศ เช่น ทุเรียน มังคุด",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: ทะเลพัทยา หรือ สวนทุเรียน"
            },
            west: {
                title: "ภาคตะวันตก",
                description: "เต็มไปด้วยผืนป่าที่อุดมสมบูรณ์และเทือกเขาสูง มีสถานที่ท่องเที่ยวทางธรรมชาติและประวัติศาสตร์ที่โดดเด่น เช่น สะพานข้ามแม่น้ำแคว น้ำตกเอราวัณ จังหวัดกาญจนบุรี และจุดชมวิวทะเลหมอกพะเนินทุ่ง",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: สะพานข้ามแม่น้ำแคว หรือ น้ำตกเอราวัณ"
            },
            south: {
                title: "ภาคใต้",
                description: "ดินแดนคาบสมุทรขนาบด้วยทะเลอันดามันและอ่าวไทย มีชื่อเสียงระดับโลกในด้านหาดทรายขาวและเกาะที่สวยงาม เช่น ภูเก็ต เกาะสมุย หมู่เกาะพีพี วัฒนธรรมโดดเด่นด้วยอาหารใต้รสเผ็ดจัดจ้านและการแสดงหนังตะลุง",
                imgText: "📷 แนะนำให้ใส่รูปภาพ: ทะเลภูเก็ต หรือ เกาะตาชัย"
            }
        };

        // ฟังก์ชันทำงานเมื่อมีการคลิกเลือกภาค
        function showInfo(regionKey) {
            const data = regionData[regionKey];
            
            // อัปเดตข้อความในหน้าเว็บ
            document.getElementById('infoTitle').innerText = data.title;
            document.getElementById('infoContent').innerHTML = `<p>${data.description}</p>`;
            
            // อัปเดตข้อความแนะนำการใส่รูปในกล่องรูปภาพ
            document.getElementById('imageContainer').innerHTML = `<span>${data.imgText}</span>`;
            
            // เพิ่มความแอนิเมชันกระพริบไฮไลท์ที่กล่องข้อมูล
            const card = document.getElementById('infoCard');
            card.classList.remove('active-card');
            void card.offsetWidth; // Trigger reflow ให้แอนิเมชันเล่นใหม่ได้ทุกครั้งที่คลิก
            card.classList.add('active-card');
        }
    </script>
</body>
</html>
